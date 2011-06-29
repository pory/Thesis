require 'models/util'
require 'models/thesis_parser'
require 'rdiscount'

class Chapter

  attr_reader :name, :sections, :number

  def initialize(name, number, path, superpath = nil)
    @name = name
    @number = number == 0 ? "" : number.to_s
    @superpath = superpath
    @path = path
    @sections = []
  end

  def section(name, &block)
    section = Chapter.new(name, compose_number, link)
    block.call(section) if block_given?
    @sections << section
  end

  def link
    return @superpath if @superpath
    return @path + "/" +Util.compose_url(name)
  end

  def formated_name
    if @number =~ /^\d./
      return numbered_name
    else
      return "<strong>#{numbered_name}</strong>"
    end
  end

  def numbered_name
    "#{@number} #{@name}"
  end

  def get_sections(result = [])
    result << self unless self.number =~ /^\d.\d./
    if sections
      sections.each { |s| s.get_sections(result) }
    end
    return result
  end

  def previous
    previous_chapter = nil
    Thesis.chapters.each do |chapter|
      break if chapter.link == self.link
      previous_chapter = chapter
    end
    return previous_chapter
  end

  def next
    was_self = false
    Thesis.chapters.each do |chapter|
      return chapter if was_self
      if chapter.link == self.link
        was_self = true
      end
    end
    return nil
  end

  def content
    begin; file = File.open(Thesis::THESIS_PATH + Util.compose_url(self.name).downcase + ".txt")
    rescue; return ""
    end
    #RDiscount.new(markdown).to_haml
    markdown = ThesisParser.parse(file)
  end  

  private

  def compose_number
    if @number != ""
      return "#{@number}.#{@sections.size + 1}"
    end
    return ""
  end

end