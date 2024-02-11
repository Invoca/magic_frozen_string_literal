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
    "*.ru"        => "# #{MAGIC_COMMENT}\n\n",
    "Rakefile"    => "# #{MAGIC_COMMENT}\n\n",
    "*.rake"      => "# #{MAGIC_COMMENT}\n\n",
    "Gemfile"     => "# #{MAGIC_COMMENT}\n\n",
    "*.gemspec"   => "# #{MAGIC_COMMENT}\n\n",
    "*.rabl"      => "# #{MAGIC_COMMENT}\n\n",
    "*.jbuilder"  => "# #{MAGIC_COMMENT}\n\n",
    "*.pbbuilder" => "# #{MAGIC_COMMENT}\n\n",
    "*.haml"      => "-# #{MAGIC_COMMENT}\n",
    "*.slim"      => "-# #{MAGIC_COMMENT}\n"
  }

  def self.process(argv)
    directory = argv.first || Dir.pwd


    touched_paths = []
    EXTENSION_COMMENTS.each do |pattern, comment|
      file_path_pattern = File.join(directory, "**", "#{pattern}")
      Dir.glob(file_path_pattern).each do |file_path|
        process_file_at(file_path, comment, touched_paths)
      end
    end

    puts "Magic comments added to #{touched_paths.size} source file(s)"
  end

  def self.process_file_at(path, comment, touched_paths)
    File.open(path, "rb+") do |file|
      lines = file.readlines
      newline = detect_newline(lines.first)
      return unless lines.any?

      if lines.first =~ SHEBANG_PATTERN
        shebang = lines.shift
      end

      # remove current magic comment(s)
      while lines.first && (lines.first.match(MAGIC_COMMENT_PATTERN) || lines.first.match(EMPTY_LINE_PATTERN))
        lines.shift
      end

      # add magic comment as the first line
      lines.unshift(comment.gsub("\n", newline))

      # put shebang back
      if shebang
        lines.unshift(shebang)
      end

      file.pos = 0
      file.print(*lines)
      file.truncate(file.pos)
    end
    touched_paths << path
  end

  def self.process_files_at(paths)
    touched_paths = []
    paths.each do |path|
      matching_pattern_and_comment = EXTENSION_COMMENTS.find do |(glob_pattern, _comment)|
        File.fnmatch(glob_pattern, path)
      end
      _, comment = matching_pattern_and_comment
      process_file_at(path, comment, touched_paths) if comment
    end

    puts "Magic comments added to #{touched_paths.size} source file(s)"
  end

  def self.detect_newline(line)
    (line[/\R/] if line) || $/
  end
end
