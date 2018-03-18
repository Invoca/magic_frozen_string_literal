# frozen_string_literal: true

# A simple library to prepend magic comments to all Ruby files in a given folder

module AddMagicComment
  MAGIC_COMMENT_PREFIX  = "frozen_string_literal".freeze
  MAGIC_COMMENT_PATTERN = /^(-|(<%))?#\s*#{MAGIC_COMMENT_PREFIX}\s*(%>)?/
  MAGIC_COMMENT         = "#{MAGIC_COMMENT_PREFIX}: true".freeze
  EMPTY_LINE_PATTERN    = /^\s$/

  EXTENSION_COMMENTS = {
    "rb"        => "# #{MAGIC_COMMENT}\n\n",
    "rake"      => "# #{MAGIC_COMMENT}\n\n",
    "rabl"      => "# #{MAGIC_COMMENT}\n\n",
    "jbuilder"  => "# #{MAGIC_COMMENT}\n\n",
    "haml"      => "-# #{MAGIC_COMMENT}\n",
    "erb"       => "<%# #{MAGIC_COMMENT} %>\n"
  }

  def self.process(argv)
    directory = argv.first || Dir.pwd

    count = 0
    EXTENSION_COMMENTS.each do |ext, comment|
      filename_pattern = File.join(directory, "**", "*.#{ext}")
      Dir.glob(filename_pattern).each do |filename|
        next unless File.size(filename) > 0
        File.open(filename, "r+") do |file|
          lines = file.readlines

          # remove current encoding comment(s)
          while lines.first && lines.first.match(MAGIC_COMMENT_PATTERN) || lines.first.match(EMPTY_LINE_PATTERN)
            lines.shift
          end

          # set current encoding
          lines.insert(0, comment)
          count += 1

          file.pos = 0
          file.puts(lines.join)
          file.truncate(file.pos)
        end
      end
    end

    puts "Magic comments added to #{count} source file(s)"
  end
end
