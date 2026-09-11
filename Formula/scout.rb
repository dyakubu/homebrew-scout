class Scout < Formula
  desc "Local, offline semantic search over your files using on-device embeddings"
  homepage "https://github.com/dyakubu/scout"
  # Bumped by scripts/bump.py after each scout release - see its usage note.
  version "0.0.7"
  # No LICENSE file exists in dyakubu/scout yet - add one there,
  # then set this field to match (e.g. license "MIT").

  on_macos do
    on_arm do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-darwin-arm64.tar.gz"
      sha256 "f1ca3a3dae57e7cabb438599ca72e3be82be7cfabf13ee0407588e4334f76e8f"
    end
    on_intel do
      # ONNX Runtime stopped publishing macOS x86_64 builds after v1.23.2.
      # Pinning scout back to it isn't a fix on its own: onnxruntime_go
      # requests C API version 29 and 1.23.2 offers 23, so the Go binding
      # would have to be downgraded for every platform.
      odie "scout has no Intel Mac build: ONNX Runtime publishes no macOS x86_64 release after v1.23.2, which is older than scout's Go bindings can drive"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-linux-amd64.tar.gz"
      sha256 "657c94d83eb26d50b3b32dcd4da3594de3a4ced66c3b526293b4c3ca0446d9a4"
    end
    on_arm do
      url "https://github.com/dyakubu/scout/releases/download/v#{version}/scout-v#{version}-linux-arm64.tar.gz"
      sha256 "1fad0ee5227091e01ee0940330f66cd0c497342db72cb15dd5e7779e83856d57"
    end
  end

  # The release archive is a self-contained bundle - scout, models/,
  # third_party/onnxruntime/ and media/ (the image search worker and its own
  # Python interpreter) - where the binary finds its assets relative to its
  # own directory (see scout's config/config.go, resolveEmbedderPaths and
  # resolveMediaPaths). Installing the whole bundle into libexec and
  # symlinking only the binary into bin preserves that: Homebrew's bin
  # symlink resolves back to the real libexec path.
  #
  # No Python dependency belongs here. The interpreter in media/ is scout's
  # own and resolves its stdlib from its own location. It does make this a
  # ~220MB download and ~420MB installed, most of it image search.
  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"scout"
  end

  test do
    assert_match "scout", shell_output("#{bin}/scout version")
  end
end
