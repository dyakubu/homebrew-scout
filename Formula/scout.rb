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
      # ONNX Runtime stopped publishing macOS x86_64 builds after v1.23.2
      # (October 2025) - both the C/C++ release archive scout's Go embedder
      # dlopens and the Python wheel its media worker needs. Pinning scout
      # back to 1.23.2 isn't a fix on its own: onnxruntime_go requests C API
      # version 29, and 1.23.2 offers at most 23, so the Go binding would
      # have to be downgraded too - holding every other platform back to an
      # October 2025 runtime, since Go modules pin one version for the whole
      # build.
      odie "scout has no Intel Mac build: ONNX Runtime publishes no macOS x86_64 release after v1.23.2, which is older than scout's Go bindings can drive"
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

  # The release archive is a self-contained bundle - scout, models/ (the
  # text embedding model plus CLIP for image search), third_party/onnxruntime/,
  # and media/ (the image search worker and its own Python interpreter) -
  # where the binary finds its assets relative to its own directory (see
  # scout's config/config.go, resolveEmbedderPaths and resolveMediaPaths).
  # Installing the whole bundle into libexec and symlinking only the binary
  # into bin preserves that: Homebrew's bin symlink resolves back to the
  # real libexec path, so scout still finds models/, third_party/ and media/
  # next to it even though bin/scout itself is just a link.
  #
  # Nothing here declares a Python dependency, and nothing should: the
  # interpreter in media/ is scout's own, resolves its stdlib from its own
  # location, and never goes on anyone's PATH. It does make this a ~220MB
  # download and ~420MB installed, most of it image search.
  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"scout"
  end

  test do
    assert_match "scout", shell_output("#{bin}/scout version")
  end
end
