class Page

  attr_reader :base_dir, :folder, :name, :filename, :output_path, :html_path
  private :base_dir, :folder, :name, :filename, :output_path, :html_path

  def initialize(input_path, output_path: nil)
    match = input_path.match(/^site\/(?<base_dir>.*)\/(?<folder>.*)\/chunks\/(?<filename>(?<name>.*)\.html)/)

    @base_dir = match[:base_dir]
    @folder = match[:folder]
    @name = match[:name]
    @filename = match[:filename]
    @html_path = File.join('/', base_dir, folder, 'chunks', filename)

    @output_path = output_path || File.join('build', base_dir, folder, filename)
  end

  def reference
    File.join(folder, filename)
  end

  def info
    {
      name: name,
      path: html_path,
      folder: folder
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
