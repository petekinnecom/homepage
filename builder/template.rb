class Template < Struct.new(:filename)
  def lines_for(page)
    [].tap do |new_lines|
      lines.each do |line|
        # remove the manual embedding, so that the automatic one doesn't write it twice
        new_lines << line.gsub("<!--\* #{page.reference} -->", '').gsub('<!-- container -->', "<!--** #{page.reference} -->")
      end
    end
  end

  private

  def lines
    File.open(filename, 'r').readlines
  end
end
