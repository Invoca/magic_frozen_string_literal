# frozen_string_literal: true

require File.expand_path('../lib/add_magic_comment.rb', __dir__)

RSpec.describe "newline code" do
  before { setup_test_files }
  after { teardown_test_files }

  let(:test_directory) do
    File.expand_path('../tmp/test', __dir__)
  end

  let(:nl_codes) do
    { lf: "\n", crlf: "\r\n", cr: "\r" }
  end

  let(:test_files) do
    nl_codes
      .keys
      .map { |nl_name| [nl_name, File.join(test_directory, "#{nl_name}.rb")] }
      .to_h
  end

  it "leaves newline code as it is", :aggregate_failures do
    AddMagicComment.process([test_directory])
    nl_codes.each do |nl_name, nl_code|
      expected = ["# frozen_string_literal: true", "", "foo", "bar"].join(nl_code)
      actual = File.binread(test_files[nl_name])
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
    nl_codes.each do |nl_name, nl_code|
      setup_test_file(nl_name, nl_code)
    end
  end

  def setup_test_file(nl_name, nl_code)
    File.binwrite(test_files[nl_name], "foo#{nl_code}bar")
  end

  def teardown_test_files
    FileUtils.rm_rf(test_directory)
  end
end
