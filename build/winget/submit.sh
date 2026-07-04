#!/bin/bash
set -e

# Submit INTERCAL-64 to winget-pkgs
# Usage: ./build/winget/submit.sh v2.0.0
# Requires: gh CLI, curl, sha256sum

VERSION="${1:?Usage: submit.sh <version-tag>}"
VERSION_NUM="${VERSION#v}"  # strip leading v
PKG_ID="PleaseAbstain.INTERCAL64"
REPO="PLEASE-ABSTAIN/INTERCAL64"
WINGET_REPO="microsoft/winget-pkgs"

# winget-pkgs layout: manifests/<letter>/<Publisher>/<Package>/<Version>/
MANIFEST_SUBPATH="manifests/p/PleaseAbstain/INTERCAL64/$VERSION_NUM"

# Fork owner = whoever is authenticated with gh (their personal fork of winget-pkgs)
FORK_OWNER=$(gh api user -q .login)

ASSET_URL="https://github.com/$REPO/releases/download/$VERSION/intercal64-$VERSION_NUM-win-x64-setup.exe"

echo "=== Submitting $PKG_ID $VERSION_NUM to winget ==="

# 1. Download the installer and compute SHA256
echo "--- Downloading $ASSET_URL ---"
TMPDIR=$(mktemp -d)
gh release download "$VERSION" --repo "$REPO" --pattern "intercal64-*-win-x64-setup.exe" --dir "$TMPDIR"
INSTALLER=$(ls "$TMPDIR"/intercal64-*-setup.exe)
SHA256=$(sha256sum "$INSTALLER" | cut -d' ' -f1 | tr '[:lower:]' '[:upper:]')
echo "SHA256: $SHA256"

# 2. Generate manifests
MANIFEST_DIR="$TMPDIR/$MANIFEST_SUBPATH"
mkdir -p "$MANIFEST_DIR"

cat > "$MANIFEST_DIR/$PKG_ID.yaml" << EOF
# yaml-language-server: \$schema=https://aka.ms/winget-manifest.version.1.6.0.schema.json
PackageIdentifier: $PKG_ID
PackageVersion: $VERSION_NUM
DefaultLocale: en-US
ManifestType: version
ManifestVersion: 1.6.0
EOF

cat > "$MANIFEST_DIR/$PKG_ID.locale.en-US.yaml" << EOF
# yaml-language-server: \$schema=https://aka.ms/winget-manifest.defaultLocale.1.6.0.schema.json
PackageIdentifier: $PKG_ID
PackageVersion: $VERSION_NUM
PackageLocale: en-US
Publisher: Please Abstain
PublisherUrl: https://github.com/PLEASE-ABSTAIN
PackageName: INTERCAL-64
PackageUrl: https://github.com/$REPO
License: MIT
ShortDescription: "INTERCAL-64: a 64-bit INTERCAL compiler and runtime"
Description: |-
  The biggest update to INTERCAL in over 25 years. 64-bit arithmetic, a complete
  system library in pure INTERCAL, a real debugger in VS Code, and a compiler named
  churn. Old dog. New ticks.
Tags:
  - intercal
  - compiler
  - esoteric
  - programming-language
ManifestType: defaultLocale
ManifestVersion: 1.6.0
EOF

cat > "$MANIFEST_DIR/$PKG_ID.installer.yaml" << EOF
# yaml-language-server: \$schema=https://aka.ms/winget-manifest.installer.1.6.0.schema.json
PackageIdentifier: $PKG_ID
PackageVersion: $VERSION_NUM
InstallerType: inno
Installers:
  - Architecture: x64
    InstallerUrl: $ASSET_URL
    InstallerSha256: $SHA256
    InstallerSwitches:
      Silent: /VERYSILENT /SUPPRESSMSGBOXES /NORESTART
      SilentWithProgress: /SILENT /SUPPRESSMSGBOXES /NORESTART
ManifestType: installer
ManifestVersion: 1.6.0
EOF

echo "--- Manifests generated in $MANIFEST_DIR ---"
ls -la "$MANIFEST_DIR"

# 3. Fork winget-pkgs, create branch, push manifests, open PR
echo "--- Submitting to $WINGET_REPO ---"
gh repo fork "$WINGET_REPO" --clone=false 2>/dev/null || true

FORK="$FORK_OWNER/winget-pkgs"
BRANCH="$PKG_ID-$VERSION_NUM"

# Clone sparse (just enough to push the manifest)
CLONE_DIR="$TMPDIR/winget-pkgs"
gh repo clone "$FORK" "$CLONE_DIR" -- --depth 1 --sparse
cd "$CLONE_DIR"
git sparse-checkout set "manifests/p/PleaseAbstain/INTERCAL64"
git checkout -b "$BRANCH"

# Copy manifests
mkdir -p "$MANIFEST_SUBPATH"
cp "$MANIFEST_DIR"/* "$MANIFEST_SUBPATH/"

git add .
git commit -m "Add $PKG_ID version $VERSION_NUM"
git push origin "$BRANCH"

# Open PR
gh pr create \
    --repo "$WINGET_REPO" \
    --head "$FORK_OWNER:$BRANCH" \
    --title "Add $PKG_ID version $VERSION_NUM" \
    --body "## Package: $PKG_ID v$VERSION_NUM

- Installer: $ASSET_URL
- SHA256: $SHA256
- Type: Inno Setup (churn.exe, intercal64-dap.exe)"

echo ""
echo "=== Done! PR submitted to $WINGET_REPO ==="

# Cleanup
rm -rf "$TMPDIR"
