class Scout < Formula
  desc "Local, offline semantic search over your files using on-device embeddings"
  homepage "https://github.com/dyakubu/scout"
  # Bumped by scripts/bump.py after each scout release - see its usage note.
  version "0.0.1"
  # No LICENSE file exists in dyakubu/scout yet - add one there,
  # then set this field to match (e.g. license "MIT").

  on_macos do
    on_arm do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-darwin-arm64.tar.gz"
      sha256 "9c194bc52c160e7b912ae40736d6787eff99fdc741c82248b4287773b0e41728"
    end
    on_intel do
      odie "scout has no Intel Mac build: ONNX Runtime publishes no osx-x64 release as of scout's pinned version"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-linux-amd64.tar.gz"
      sha256 "9abcff1be4f15c294f27e6fb9a730d3c775988a6f39710a0d4b867b8632516f5"
    end
    on_arm do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-linux-arm64.tar.gz"
      sha256 "6b65c190c3011030dad4467a50b4b29d9383be730909f5dd10bdc45ffbc9e2ab"
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
