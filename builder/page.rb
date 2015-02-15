class Page < Struct.new(:input_path, :output_path)

  def initialize(input_path, output_path: nil)
    super(input_path, output_path || input_path.sub(/\/chunks/, '').sub(/^site/, 'build'))
  end

  def filename
    File.basename(input_path)
  end

  def name
    filename.sub(/\.html$/, '')
  end

  def reference
    page_dir = input_path.match(/\/([^\/]+)\/chunks/)[1]
    File.join(page_dir, filename)
  end

  def html_path
    input_path.sub(/^site/, '')
  end

  def info
    {
      name: name,
      path: html_path,
    }
  end

  def compile(template)
    template_lines = template.lines_for(self)
    new_lines = []

    template_lines.each do |line|
      match = line.match(/<!--\*(?<visible>\*?) (?<page>(.*)) -->/) #eg: <!--* page_name -->

      if match
        visible = match[:visible].length > 0
        file_name = File.basename(match[:page])
        dir_name = File.dirname(match[:page])
        file_path = File.join('site/pages', dir_name, 'chunks', file_name)

        page_name = match[:page].gsub(/\.html$/, '')
        div_open  =  %{<div data-page-name="#{page_name}" style="display: #{visible ? "block" : "none"};">}
        div_close = "</div>"

        page_contents = File.read(file_path).gsub(/\r/, '').gsub(/\n/, '')

        new_lines << [div_open, page_contents, div_close].join('')
      else
        new_lines << line
      end
    end

    File.open(output_path, 'w') do |f|
      new_lines.each do |line|
        f.puts line
      end
    end
  end
end
