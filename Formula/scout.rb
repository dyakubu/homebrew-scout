class Scout < Formula
  desc "Local, offline semantic search over your files using on-device embeddings"
  homepage "https://github.com/dyakubu/scout"
  # Bumped by scripts/bump.py after each scout release - see its usage note.
  version "0.0.5"
  # No LICENSE file exists in dyakubu/scout yet - add one there,
  # then set this field to match (e.g. license "MIT").

  on_macos do
    on_arm do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-darwin-arm64.tar.gz"
      sha256 "fe6d95b67a849f70bc5bf81e7ddcba7422f9efc8b51364543dc73304ec86cf9d"
    end
    on_intel do
      odie "scout has no Intel Mac build: ONNX Runtime publishes no osx-x64 release as of scout's pinned version"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-linux-amd64.tar.gz"
      sha256 "3de943bdee57f6d2bb09cc689bea7f87748befc5d124ad2625e395d287412943"
    end
    on_arm do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-linux-arm64.tar.gz"
      sha256 "fbe7ddb7407434a73bc47ccf559c1cb88154f24f3c0c73cddb8973941bddc025"
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
