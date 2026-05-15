class Pif < Formula
  desc "PIF - A CLI package manager for interactive fiction languages"
  homepage "https://github.com/toerob/pif"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/toerob/pif/releases/download/v0.2.2/pif-aarch64-apple-darwin.tar.xz"
      sha256 "9af4ece974091801e1c38d8259320cd301c64003126cfa30c16c56bf61136067"
    end
    if Hardware::CPU.intel?
      url "https://github.com/toerob/pif/releases/download/v0.2.2/pif-x86_64-apple-darwin.tar.xz"
      sha256 "d7684940c2d5ee71168befcb402ea3f61693ffb9c035a91e24457aab4843a9bf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/toerob/pif/releases/download/v0.2.2/pif-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ac46daaba6af029271f694fdc0e22841d425a0dabd575852213152652159e57a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/toerob/pif/releases/download/v0.2.2/pif-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4f3688c1526a9d815c6b2e0b45be721450f9a7955ac438deb10e9cbefc901a52"
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
