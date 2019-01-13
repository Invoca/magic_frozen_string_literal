# frozen_string_literal: true

# A simple library to prepend magic comments to all Ruby files in a given folder

module AddMagicComment
  MAGIC_COMMENT_PREFIX  = "frozen_string_literal".freeze
  MAGIC_COMMENT_PATTERN = /^(-|(<%))?#\s*#{MAGIC_COMMENT_PREFIX}\s*(%>)?/
  MAGIC_COMMENT         = "#{MAGIC_COMMENT_PREFIX}: true".freeze
  EMPTY_LINE_PATTERN    = /^\s$/
  SHEBANG_PATTERN       = /^#!/

  EXTENSION_COMMENTS = {
    "*.rb"        => "# #{MAGIC_COMMENT}\n\n",
    "Gemfile"    => "# #{MAGIC_COMMENT}\n\n",
    "Rakefile"    => "# #{MAGIC_COMMENT}\n\n",
    "*.rake"      => "# #{MAGIC_COMMENT}\n\n",
    "*.rabl"      => "# #{MAGIC_COMMENT}\n\n",
    "*.jbuilder"  => "# #{MAGIC_COMMENT}\n\n",
    "*.haml"      => "-# #{MAGIC_COMMENT}\n",
    "*.slim"      => "-# #{MAGIC_COMMENT}\n"
  }

  def self.process(argv)
    directory = argv.first || Dir.pwd

    count = 0
    EXTENSION_COMMENTS.each do |pattern, comment|
      filename_pattern = File.join(directory, "**", "#{pattern}")
      Dir.glob(filename_pattern).each do |filename|
        File.open(filename, "r+") do |file|
          lines = file.readlines
          next unless lines.any?
          count += 1

          if lines.first =~ SHEBANG_PATTERN
            shebang = lines.shift
          end

          # remove current magic comment(s)
          while lines.first && (lines.first.match(MAGIC_COMMENT_PATTERN) || lines.first.match(EMPTY_LINE_PATTERN))
            lines.shift
          end

          # add magic comment as the first line
          lines.unshift(comment)

          # put shebang back
          if shebang
            lines.unshift(shebang)
          end

          file.pos = 0
          file.puts(lines.join)
          file.truncate(file.pos)
        end
      end
    end

    puts "Magic comments added to #{count} source file(s)"
  end
end
