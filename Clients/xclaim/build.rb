require 'erb'
require 'fileutils'

src_templates = Dir.children(File.join(__dir__, "src"))
  .map { |name| File.join(__dir__, "src", name) }
  .reject { |path| File.directory?(path) }

class TemplateContext
  def initialize(template_contents)
    @template_contents = template_contents
  end
  attr_reader :template_contents

  def includes(partial_filename)
    # In order to produce valid yaml output, we need to match the leading
    # whitespace of the partial contents to the line that is including it
    # in the template. Use some meta-programming magic to find the call-site
    # in the ERB template and count its leading whitespace, then pad each
    # line of the partial before it gets returned to ERB.

    lineno_match = /\(erb\):(\d+):in `get_binding'/.match(Kernel.caller[0])
    lineno = lineno_match[1].to_i - 1
    line_contents = template_contents.lines[lineno]
    leading_spaces = /^(\s+)/.match(line_contents)[1].length

    partial_contents = File.read(File.join(__dir__, "src", "includes", partial_filename))
    partial_lines = partial_contents.each_line

    partial_whitespace_corrected = [partial_lines.take(1)] + partial_lines.drop(1).map { |l| "#{" " * leading_spaces}#{l}" }

    return partial_whitespace_corrected.join
  end

  def get_binding
    binding
  end
end

build_dir = File.join(__dir__, "build")
Dir.mkdir(build_dir) unless File.exists?(build_dir)

src_templates.each do |src_template|
  if File.extname(src_template) == ".erb"
    dst_filename = File.join(__dir__, "build", File.basename(src_template.gsub(/\.erb\z/, "")))

    template_contents = File.read(src_template)
    template_context = TemplateContext.new(template_contents)
    template = ERB.new(template_contents)
    processed_template = template.result(template_context.get_binding)

    File.write(dst_filename, processed_template)

    puts "Process ERB: #{src_template} -> #{dst_filename}"
  else
    dst_filename = File.join(__dir__, "build", File.basename(src_template))
    FileUtils.copy(src_template, dst_filename)

    puts "Copy: #{src_template} -> #{dst_filename}"
  end
end
