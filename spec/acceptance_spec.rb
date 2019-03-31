# frozen_string_literal: true

require_relative '../lib/add_magic_comment.rb'

RSpec.describe "acceptance" do
  before { setup_test_files }
  after { teardown_test_files }

  let(:directories) do
    {
      test: File.expand_path('../tmp/test', __dir__),
      input: File.expand_path('fixtures/input', __dir__),
      expected: File.expand_path('fixtures/expected', __dir__),
    }
  end

  it "inserts magic comments where expected", :aggregate_failures do
    AddMagicComment.process([directories[:test]])

    Dir["#{directories[:test]}/*"].each do |path|
      assert_file_matches_expected(File.basename(path))
    end
  end

  def setup_test_files
    FileUtils.mkdir_p(File.dirname(directories[:test]))
    FileUtils.cp_r(directories[:input], directories[:test])
  end

  def teardown_test_files
    FileUtils.rm_rf(directories[:test])
  end

  def assert_file_matches_expected(filename)
    paths = {
      test: File.join(directories[:test], filename),
      expected: File.join(directories[:expected], filename),
    }
    expect(FileUtils).to be_identical(*paths.values), <<~ERROR
      Expected contents of #{paths[:test]} to match #{paths[:expected]}.

      Expected:
      #{File.read(paths[:expected])}

      Actual:
      #{File.read(paths[:test])}
    ERROR
  end
end
