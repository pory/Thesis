require 'stringio'
require 'fakefs/safe'

module FakeFS
  
  class Dir
    def self.entries(dirname)
      FileSystem.fs
      raise SystemCallError, dirname unless FileSystem.find(dirname)
      Dir.new(dirname).map { |file| File.basename(file) }
    end
  end

  module FileSystem
    def fs
      @fs ||= FakeDir.new("/")
    end

    def normalize_path(path)
      if Pathname.new(path).absolute?
        File.expand_path(path)
      else
        parts = [""] + dir_levels + [path]
        File.expand_path(File.join(*parts))
      end
    end
    
    def current_dir
      parts = FileSystem.dir_levels
      return fs if parts.empty? # '/'
      entries = find_recurser(fs, parts).flatten

      return case entries.length
      when 0 then nil
      when 1 then entries.first
      else entries
      end
    end
  end

  class FakeDir
    def to_s
      if parent && parent.to_s == '/'
        File.join("", name)
      elsif parent
        part_parent = parent.to_s.split(File::PATH_SEPARATOR).reject { |part| part.empty? }
        File.join("", part_parent, name)
      else
        "/"
      end
    end
    
  end

  class FakeFile
    
    def to_s
      if parent && parent.to_s == '/'
        File.join("", name)
      elsif parent
        part_parent = parent.to_s.split(File::PATH_SEPARATOR).reject { |part| part.empty? }
        File.join("", part_parent, name)
      else
        name
      end
    end
    
  end

  class File
    def inspect
      "#<File:#{@path}>"
    end
      
    def self.foreach(path)
      self.read(path).each_line {|line| yield(line) }
    end

    def self.expand_path(*args)
      file_name, dir_string = args
      dir_string ||= FileSystem.current_dir.to_s
      if file_name == "/"
        return "/"
      elsif (file_name.start_with?("/"))
        abs_file_name = RealFile.join(file_name)
      else
        abs_file_name = RealFile.join(dir_string, file_name)
      end
      path_parts = abs_file_name.split(RealFile::Separator)
      result_path_parts = [""]
      path_parts.each do |part|
        case part
        when ".." then result_path_parts.pop
        when "." then # ignore
        else result_path_parts.push(part)
        end
      end
      RealFile.join(*result_path_parts)
    end

  end
  
  module FileUtils
    def copy(src, dest)
      cp(src, dest)
      nil
    end
  end
end

module TryRuby
  extend self
  
  class Session
    attr_accessor :past_commands, :current_statement, :start_time
    def initialize
      @past_commands = ''
      @current_statement = ''
      @start_time = Time.now
    end
  end
  
  class Output
    attr_reader :type, :result, :output, :error, :indent_level, :javascript
    def self.standard(params = {})
      Output.new :type => :standard, :result => params[:result], :output => params[:output] || ''
    end
    def self.illegal
      Output.new :type => :illegal
    end
    def self.javascript(js)
      Output.new :type => :javascript, :javascript => js
    end
    def self.no_output
      Output.standard :result => nil
    end
    def self.line_continuation(level)
      Output.new :type => :line_continuation, :indent_level => level
    end
    def self.error(params = {})
      params[:error] ||= StandardError.new('TryRuby Error')
      params[:error].message.gsub! /\(eval\):\d*/, '(TryRuby):1'
      Output.new :type => :error, :error => params[:error],
        :output => params[:output] || ''
    end
    def format
      case @type
      when :line_continuation
        ".." * @indent_level
      when :error
        @output + "#{@error.class}: #{@error.message}"
      when :illegal
        "You aren't allowed to run that command!"
      when :javascript
        "#{@javascript}"
      else
        @output + "=> #{@result.inspect}"
      end
    end
    
    protected
    def initialize(values = {})
      values.each do |variable, value|
        instance_variable_set("@#{variable}", value)
      end
    end
  end
  
  def run_line(code)
    case code.strip
    when '!INIT!IRB!'
      return Output.no_output
    when 'reset'
      return Output.no_output
    when 'time'
      seconds = (Time.now - session.start_time).ceil
      return Output.standard :result =>
        if seconds < 60; "#{seconds} seconds"
        elsif seconds < 120; "1 minute"
        else; "#{seconds / 60} minutes"
        end
    end
    
    FakeFS.activate!
    stdout_id = $stdout.to_i
    $stdout = StringIO.new
    cmd = <<-EOF
    $SAFE = 3
    $stdout = StringIO.new
    begin
      #{code}
    end
    EOF
    begin
      result = Thread.new { eval cmd, TOPLEVEL_BINDING }.value
    rescue SecurityError => e
      puts e
      return Output.illegal
    rescue Exception => e
      return Output.error :error => e, :output => get_stdout
    ensure
      output = get_stdout
      $stdout = IO.new(stdout_id)
      FakeFS.deactivate!
    end
    return result if result.is_a? Output and result.type == :javascript
    Output.standard :result => result, :output => output
  end
  
  private
  def get_stdout
    raise TypeError, "$stdout is a #{$stdout.class}" unless $stdout.is_a? StringIO
    $stdout.rewind
    $stdout.read
  end
  
end