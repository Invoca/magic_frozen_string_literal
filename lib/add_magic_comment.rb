# frozen_string_literal: true

# A simple library to prepend magic comments to all Ruby files in a given folder

module AddMagicComment
  MAGIC_COMMENT_PREFIX  = "frozen_string_literal".freeze
  MAGIC_COMMENT_PATTERN = /^(-|(<%))?#\s*#{MAGIC_COMMENT_PREFIX}\s*(%>)?/
  MAGIC_COMMENT         = "#{MAGIC_COMMENT_PREFIX}: true".freeze
  EMPTY_LINE_PATTERN    = /^\s$/
  SHEBANG_PATTERN       = /^#!/

  EXTENSION_COMMENTS = {
    "*.rb"        => ["# #{MAGIC_COMMENT}", 2],
    "*.ru"        => ["# #{MAGIC_COMMENT}", 2],
    "Gemfile"     => ["# #{MAGIC_COMMENT}", 2],
    "Rakefile"    => ["# #{MAGIC_COMMENT}", 2],
    "*.rake"      => ["# #{MAGIC_COMMENT}", 2],
    "*.rabl"      => ["# #{MAGIC_COMMENT}", 2],
    "*.jbuilder"  => ["# #{MAGIC_COMMENT}", 2],
    "*.haml"      => ["-# #{MAGIC_COMMENT}", 1],
    "*.slim"      => ["-# #{MAGIC_COMMENT}", 1]
  }

  def self.process(argv)
    directory = argv.first || Dir.pwd

    count = 0
    EXTENSION_COMMENTS.each do |pattern, (comment, num_nl_codes)|
      filename_pattern = File.join(directory, "**", "#{pattern}")
      Dir.glob(filename_pattern).each do |filename|
        File.open(filename, "rb+") do |file|
          contents = file.read
          nl_code = detect_nl_code(contents)
          lines = contents.lines(nl_code)
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
          lines.unshift("#{comment}#{nl_code * num_nl_codes}")

          # put shebang back
          if shebang
            lines.unshift(shebang)
          end

          file.pos = 0
          file.print(*lines)
          file.truncate(file.pos)
        end
      end
    end

    puts "Magic comments added to #{count} source file(s)"
  end

  def self.detect_nl_code(contents)
    if /(\R)/ =~ contents
      $1
    else
      $/
    end
  end
end
