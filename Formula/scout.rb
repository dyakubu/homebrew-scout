class Scout < Formula
  desc "Local, offline semantic search over your files using on-device embeddings"
  homepage "https://github.com/dyakubu/scout"
  # Bumped by scripts/bump.py after each scout release - see its usage note.
  version "0.0.6"
  # No LICENSE file exists in dyakubu/scout yet - add one there,
  # then set this field to match (e.g. license "MIT").

  on_macos do
    on_arm do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-darwin-arm64.tar.gz"
      sha256 "2e33284b140a31570dfa8b19c10ea1579b19334d347194b2c5cfb72f0ccec44b"
    end
    on_intel do
      odie "scout has no Intel Mac build: ONNX Runtime publishes no osx-x64 release as of scout's pinned version"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-linux-amd64.tar.gz"
      sha256 "5b43ea9eaa0a850ee75073bf72120cb1155a156a7a639eba24487184076f2721"
    end
    on_arm do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-linux-arm64.tar.gz"
      sha256 "73203db33a5b36a4bc55303ab5d10ca8d16995b358c691fefc3d85c8fbf7696f"
    end
  end

  # The release archive is a self-contained bundle - scout, models/, and
  # third_party/onnxruntime/ - where the binary finds its assets relative
  # to its own directory (see scout's config/config.go, resolveEmbedderPaths).
  # Installing the whole bundle into libexec and symlinking only the binary
  # into bin preserves that: Homebrew's bin symlink resolves back to the
  # real libexec path, so scout still finds models/ and third_party/ next
  # to it even though bin/scout itself is just a link.
  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"scout"
  end

  test do
    assert_match "scout", shell_output("#{bin}/scout version")
  end
end
