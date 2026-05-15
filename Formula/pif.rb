class Pif < Formula
  desc "PIF - A CLI package manager for interactive fiction languages"
  homepage "https://github.com/toerob/pif"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/toerob/pif/releases/download/v0.2.4/pif-aarch64-apple-darwin.tar.xz"
      sha256 "fa9de29b3597c92c0ea0a70386da350a17ee122525fb33c1ee6c4c6186a5e1fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/toerob/pif/releases/download/v0.2.4/pif-x86_64-apple-darwin.tar.xz"
      sha256 "a1c3a744cf4857d17b73de229034049804007f1b9e21caae1189a800e26defbf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/toerob/pif/releases/download/v0.2.4/pif-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f1ed2020f9417f6660a6f28ed30c9609844c1befc46cf5b9e5edaf3f036c4581"
    end
    if Hardware::CPU.intel?
      url "https://github.com/toerob/pif/releases/download/v0.2.4/pif-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "907c74ca6001e71cd1699ed701963710b0a3dd7856891e75f3d04c87cbcb0f53"
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
