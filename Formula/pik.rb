class Pik < Formula
  desc "Lightweight Git GUI with line-level staging"
  homepage "https://github.com/t4traw/pik"
  version "0.1.2"
  url "https://github.com/t4traw/pik/releases/download/v#{version}/pik-v#{version}-darwin-universal.tar.gz"
  sha256 "95f5d64f204ccfc27aed5b7f9f315610dcce4dd2b55019ea0f40ad0ff4af4ab9"
  license "MIT"

  depends_on :macos

  def install
    # Tarball has `pik.app/` as the single top-level directory, so Homebrew
    # auto-strips it on extraction — cwd is already inside the bundle.
    # Reconstruct it at the install destination to keep codesign intact.
    (prefix/"pik.app").install Dir["*"]

    # Expose a `pik` CLI that exec's the Mach-O inside the installed bundle.
    # Using opt_prefix keeps the symlink stable across version bumps.
    (bin/"pik").write <<~SH
      #!/bin/sh
      exec "#{opt_prefix}/pik.app/Contents/MacOS/pik" "$@"
    SH
    (bin/"pik").chmod 0755
  end

  test do
    assert_predicate prefix/"pik.app/Contents/MacOS/pik", :executable?
  end
end
