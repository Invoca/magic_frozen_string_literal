# frozen_string_literal: true

# A simple library to prepend magic comments for encoding to multiple ".rb" files

module AddMagicComment

  # Options :
  # 1 : Encoding
  # 2 : Path
  # TODO : check that the encoding specified is a valid encoding
  # TODO : allow use of only one option, so the encoding would be guessed (maybe using `file --mime`?)
  def self.process(options)

    directory = options[0] || Dir.pwd

    prefix = "frozen_string_literal: true"

    # TODO : add options for recursivity (and application of the script to a single file)

    extensions = {
      'rb' => '# {text}',
      'rake' => '# {text}',
      'haml' => '-# {text}',
    }

    count = 0
    extensions.each do |ext, comment_style|
      rbfiles = File.join(directory, "**", "*.#{ext}")
      Dir.glob(rbfiles).each do |filename|
        File.new(filename, "r+") do |file|
          lines = file.readlines

          # remove current encoding comment(s)
          while lines[0].match(/^-?# *frozen_string_literal/)
            lines.shift
          end

          # set current encoding
          lines.insert(0, comment_style.sub('{text}', prefix))
          count += 1

          file.pos = 0
          file.puts(lines.join)
        end
      end
    end

    puts "Magic comments added to #{count} source file(s)"
  end
end
