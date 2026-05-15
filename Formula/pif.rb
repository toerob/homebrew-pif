class Pif < Formula
  desc "PIF - A CLI package manager for interactive fiction languages"
  homepage "https://github.com/toerob/pif"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/toerob/pif/releases/download/v0.2.3/pif-aarch64-apple-darwin.tar.xz"
      sha256 "d4a1c0f80e5c9e8cf8ddfc398bfc5b4ff28f59be9d3fee952ac95070a0e872bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/toerob/pif/releases/download/v0.2.3/pif-x86_64-apple-darwin.tar.xz"
      sha256 "158a137318fca60cb093b5d4f8101616e7b3b18096e4540a4e9d0a1b1f0e9d21"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/toerob/pif/releases/download/v0.2.3/pif-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1bd0cb5f9b075e4e72928238591eb6404302fc9b017b1c564649040e1c5d8b5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/toerob/pif/releases/download/v0.2.3/pif-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3553c79da014225cba070c4279f1108b91196b6cee5a2f1d2f69a22f175f3d8a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "pif" if OS.mac? && Hardware::CPU.arm?
    bin.install "pif" if OS.mac? && Hardware::CPU.intel?
    bin.install "pif" if OS.linux? && Hardware::CPU.arm?
    bin.install "pif" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
