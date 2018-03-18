require "bundler/gem_tasks"
require "shellwords"

task default: :test

task :test do
  system("rm -rf ./test-output")
  system("cp -r ./test-input ./test-output")
  system("ruby -Ilib/ ./bin/magic_frozen_string_literal ./test-output/")

  success = true

  count = 0
  successes = 0
  Dir.glob("test-output/*").each do |filename|
    count += 1
    escaped_args = ["test-expected/#{File.basename(filename)}", filename].map { |word| Shellwords.shellescape(word) }
    if system("diff -c #{escaped_args.join(' ')}")
      successes += 1
    end
  end

  puts "#{successes} of #{count} tests passed"
  if successes == count
    system("rm -rf ./test-output")
    exit 0
  else
    exit 1
  end
end
