class Pif < Formula
  desc "PIF - A CLI package manager for interactive fiction languages"
  homepage "https://github.com/toerob/pif"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/toerob/pif/releases/download/v0.1.0/pif-aarch64-apple-darwin.tar.xz"
      sha256 "dfdd51b464ce1b21cdec0514afb265065190925ce67fbfbd9c32415538cf9c9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/toerob/pif/releases/download/v0.1.0/pif-x86_64-apple-darwin.tar.xz"
      sha256 "2033c0ad65fb2b8d529da7a05783e10757e4a6c2d1e43aa66b007a7ecafc5e11"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/toerob/pif/releases/download/v0.1.0/pif-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cce832e9647ddeaa40561468eb4059f20a9ced9002fb140e198433e1f29d2bb6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/toerob/pif/releases/download/v0.1.0/pif-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3aa98c2ca912d4339e33a709029bff470d7b1260a3e0e61cbbea8490ff1d3053"
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
