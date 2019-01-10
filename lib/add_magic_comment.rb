# frozen_string_literal: true

# A simple library to prepend magic comments to all Ruby files in a given folder

module AddMagicComment
  MAGIC_COMMENT_PREFIX  = "frozen_string_literal"
  MAGIC_COMMENT_PATTERN = /^(-|(<%))?#\s*#{MAGIC_COMMENT_PREFIX}\s*(%>)?/
  MAGIC_COMMENT         = "#{MAGIC_COMMENT_PREFIX}: true"

  PATTERNS = [
    {comment: "# #{MAGIC_COMMENT}", extnames: %w[rb rake ru rabl jbuilder]},
    {comment: "-# #{MAGIC_COMMENT}", extnames: %w[haml slim]},
    {comment: "<%# #{MAGIC_COMMENT} %>", extnames: %w[erb]},
  ].freeze

  def self.process(argv)
    directory = argv.first || Dir.pwd

    count = 0
    PATTERNS.each do |pattern|
      comment = pattern[:comment]
      pattern[:extnames].each do |ext|
        filename_pattern = File.join(directory, "**", "*.#{ext}")
        Dir.glob(filename_pattern).each do |filename|
          next unless File.size(filename) > 0
          File.open(filename, "r+") do |file|
            lines = file.readlines

            # remove current encoding comment(s)
            while lines.first && (lines.first.match(MAGIC_COMMENT_PATTERN) || lines.first.strip == '')
              lines.shift
            end

            # set current encoding
            lines.insert(0, comment + "\n\n")
            count += 1

            file.pos = 0
            file.puts(lines.join)
            file.truncate(file.pos)
          end
        end
      end
    end

    puts "Magic comments added to #{count} source file(s)"
  end
end
