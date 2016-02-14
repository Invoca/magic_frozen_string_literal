# frozen_string_literal: true

# A simple library to prepend magic comments to multiple ".rb" files

module AddMagicComment
  MAGIC_COMMENT_PREFIX  = "frozen_string_literal"
  MAGIC_COMMENT_PATTERN = /^(-|(<%))?#\s*#{MAGIC_COMMENT_PREFIX}\s*(%>)?/m
  MAGIC_COMMENT         = "#{MAGIC_COMMENT_PREFIX}: true"

  EXTENSIONS = {
    'rb'   => '# {text}',
    'rake' => '# {text}',
    'haml' => '-# {text}',
    'erb'  => '<%# {text}'
  }

  # Options :
  # 1 : Encoding
  # 2 : Path
  # TODO : check that the encoding specified is a valid encoding
  # TODO : allow use of only one option, so the encoding would be guessed (maybe using `file --mime`?)
  def self.process(options)

    directory = options[0] || Dir.pwd


    # TODO : add options for recursivity (and application of the script to a single file)

    count = 0
    EXTENSIONS.each do |ext, comment_style|
      rbfiles = File.join(directory, "**", "*.#{ext}")
      case ext
        when 'erb'
          comment = "#{MAGIC_COMMENT} %>\n"
        else
          comment = "#{MAGIC_COMMENT}\n"
      end
      frozen_literal_string_comment = comment_style.sub('{text}', comment)
      Dir.glob(rbfiles).each do |filename|
        File.open(filename, "r+") do |file|
          lines = file.readlines

          # remove current encoding comment(s)
          while lines[0]&.match(MAGIC_COMMENT_PATTERN)
            lines.shift
          end

          # set current encoding
          lines.insert(0, frozen_literal_string_comment)
          count += 1

          file.pos = 0
          file.puts(lines.join)
        end
      end
    end

    puts "Magic comments added to #{count} source file(s)"
  end
end
