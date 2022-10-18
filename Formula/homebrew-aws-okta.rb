# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class HomebrewAwsOkta < Formula
  desc "aws-vault like tool for Okta authentication"
  homepage ""
  url "https://github.com/RukmaniDT/homebrew-aws-okta/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "8e06ea8297e20e859c2cb09a2a18d6a4776be4122f360bb2a753798080c2fa04"
  license "MIT"

bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52451bf142c4c9253a88a93c599e894299d6d2e1c4c0fae07c92cfb16eab1ac7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6de4fd8fa42cddba3a914ed99123469230646bc2ac2598ff40fd0d0c9bf51efe"
    sha256 cellar: :any_skip_relocation, monterey:       "af6cea2f20202c5b10749615f86847d0c3c82d812b7559948d0ab6b886a0f2fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "178f359eaabc71c8a677f89e1acb35fe73ae35ba4010a06876bdb630b66878b2"
    sha256 cellar: :any_skip_relocation, catalina:       "2edc4ebb817ff4f0a3188a0c0eea6416ce2a83a6d9b5cc5b3969034ee65e27ca"
    sha256 cellar: :any_skip_relocation, mojave:         "910418c2dd89b78a7d665cdd8082d9941de433c6c8db800ce0515dfb6c1eb25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108a796410008799835a58ab990dca87d12e602bff10a47f49b6b126f223b36c"
  end

  # See https://github.com/segmentio/aws-okta/issues/278
  disable! date: "2022-07-31", because: :deprecated_upstream

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    require "pty"

    PTY.spawn("#{bin}/aws-okta --backend file add") do |input, output, _pid|
      output.puts "organization\n"
      input.gets
      output.puts "us\n"
      input.gets
      output.puts "fakedomain.okta.com\n"
      input.gets
      output.puts "username\n"
      input.gets
      output.puts "password\n"
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      assert_match "Failed to validate credentials", input.gets.chomp
      input.close
    end
  end
end
