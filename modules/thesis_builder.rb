module ThesisBuilder

  THESIS_ROOT = "/diplomova-prace"

  @@chapters = []
  @@numbering_chapters_count = 0

  def chapter(name, options = {}, &block)
    chapter = Chapter.new(name, chapter_number(options[:numbering]), THESIS_ROOT, options[:path])
    block.call(chapter) if block_given?
    @@chapters << chapter
  end
  
  def chapters
    chapters = []
    @@chapters.each do |chapter|
      chapters << chapter.get_sections
    end
    return chapters.flatten
  end

  def find(chapter_link)
    if chapter_link == :root
      return chapters.select { |c| c.link == THESIS_ROOT }.first
    else
      return chapters.select { |c| c.link == THESIS_ROOT + "/" + chapter_link }.first
    end
  end  
  
  private
  
  def chapter_number(option)
    unless option == :no
      return @@numbering_chapters_count += 1
    end
    return 0
  end  
end