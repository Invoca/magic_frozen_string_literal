# frozen_string_literal: true

require File.expand_path('../lib/add_magic_comment.rb', __dir__)

RSpec.describe "newline code" do
  before { setup_test_files }
  after { teardown_test_files }

  let(:test_directory) do
    File.expand_path('../tmp/test', __dir__)
  end

  let(:newlines) do
    { lf: "\n", crlf: "\r\n", cr: "\r" }
  end

  let(:test_files) do
    newlines
      .keys
      .map { |newline_name| [newline_name, File.join(test_directory, "#{newline_name}.rb")] }
      .to_h
  end

  it "leaves newline code as it is", :aggregate_failures do
    AddMagicComment.process([test_directory])
    newlines.each do |newline_name, newline|
      expected = ["# frozen_string_literal: true", "", "foo", "bar"].join(newline)
      actual = File.binread(test_files[newline_name])
      expect(actual).to eq(expected), <<~ERROR
        Expected newline code to be leaved as it is but it was changed.

        Expected:
        #{expected.inspect}

        Actual:
        #{actual.inspect}
      ERROR
    end
  end

  def setup_test_files
    FileUtils.mkdir_p(test_directory)
    newlines.each do |newline_name, newline|
      setup_test_file(newline_name, newline)
    end
  end

  def setup_test_file(newline_name, newline)
    File.binwrite(test_files[newline_name], "foo#{newline}bar")
  end

  def teardown_test_files
    FileUtils.rm_rf(test_directory)
  end
end
