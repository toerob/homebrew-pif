class Pif < Formula
  desc "PIF - A CLI package manager for interactive fiction languages"
  homepage "https://github.com/toerob/pif"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/toerob/pif/releases/download/v0.1.0/pif-aarch64-apple-darwin.tar.xz"
      sha256 "0cb39c558cfb7c3e11374806428cb5a4981009175fd04beae7acc2c5fa345ca9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/toerob/pif/releases/download/v0.1.0/pif-x86_64-apple-darwin.tar.xz"
      sha256 "3fb2d15f3aac1451d06248a6e92b7a51444989d5e62ecc1c44c7b74bade67b36"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/toerob/pif/releases/download/v0.1.0/pif-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ef4b1cb0496af13a75dc826482a6b7e4d413709bf8a4d25990e28895ab641fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/toerob/pif/releases/download/v0.1.0/pif-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "27fb92f52fdaccd02a48b05f0b49d885340f0ae078423793489a6e3d0a3be1a0"
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
