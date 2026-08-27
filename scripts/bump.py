#!/usr/bin/env python3
"""Bumps Formula/scout.rb to a newly published scout release.

Pulls each platform's tarball checksum straight from that release's
.sha256 asset (published by scout's own release workflow, see
scripts/package-release.sh in daniel13112001/scout) rather than
re-downloading and re-hashing the tarballs itself.

Usage: scripts/bump.py v0.1.0
"""
import re
import sys
import urllib.request
from pathlib import Path

REPO = "daniel13112001/scout"
PLATFORMS = ["darwin-arm64", "linux-amd64", "linux-arm64"]


def sha_for(version: str, platform: str) -> str:
    asset = f"scout-{version}-{platform}.tar.gz"
    url = f"https://github.com/{REPO}/releases/download/{version}/{asset}.sha256"
    with urllib.request.urlopen(url) as resp:
        return resp.read().decode().split()[0]


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit("usage: scripts/bump.py vX.Y.Z")
    version = sys.argv[1]
    version_num = version.lstrip("v")

    formula_path = Path(__file__).resolve().parent.parent / "Formula" / "scout.rb"
    text = formula_path.read_text()

    text, n = re.subn(r'version "[^"]*"', f'version "{version_num}"', text, count=1)
    if n != 1:
        sys.exit("could not find a version line to update")

    for platform in PLATFORMS:
        sha = sha_for(version, platform)
        pattern = re.compile(
            r'(url "[^"]*' + re.escape(platform) + r'[^"]*"\s*\n\s*sha256 ")[^"]*(")'
        )
        text, n = pattern.subn(lambda m: m.group(1) + sha + m.group(2), text, count=1)
        if n != 1:
            sys.exit(f"could not find a sha256 line for {platform}")
        print(f"{platform}: {sha}")

    formula_path.write_text(text)
    print(f"\nbumped Formula/scout.rb to {version}")
    print(f"next: git commit -am 'scout {version}' && git push")


if __name__ == "__main__":
    main()
