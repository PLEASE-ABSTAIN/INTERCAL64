# Homebrew formula for INTERCAL-64
# Install: brew tap please-abstain/intercal64 && brew install intercal64
# Usage: churn hello.i && ./hello

class Intercal64 < Formula
  desc "INTERCAL-64 — a 64-bit INTERCAL compiler and runtime"
  homepage "https://github.com/PLEASE-ABSTAIN/INTERCAL64"
  version "2.0.3"

  if Hardware::CPU.arm?
    url "https://github.com/PLEASE-ABSTAIN/INTERCAL64/releases/download/v2.0.3/intercal64-v2.0.3-osx-arm64.tar.gz"
    sha256 "a382655b8857b0d24f95273cd846c0f024650f4744829c46cd7810000e941c12"
  else
    url "https://github.com/PLEASE-ABSTAIN/INTERCAL64/releases/download/v2.0.3/intercal64-v2.0.3-osx-x64.tar.gz"
    sha256 "54b22ae0ef5da13c12a9e31267d42de5f392ab575073cfc229a0ff1f621450ec"
  end

  def install
    bin.install "bin/churn"
    bin.install "bin/intercal64-dap"
    lib.install "lib/intercal64.runtime.dll"
    lib.install "lib/syslib64.dll"
    (share/"intercal64/samples").install Dir["samples/*.i"]
    # Copy runtime and syslib to samples so they compile out of the box
    cp lib/"intercal64.runtime.dll", share/"intercal64/samples/"
    cp lib/"syslib64.dll", share/"intercal64/samples/"
    doc.install "debugger-install.md"
  end

  def post_install
    # Install VS Code extension if VS Code is present
    vsix = Dir[prefix/"*.vsix"].first
    if vsix && which("code")
      system "code", "--install-extension", vsix
    end
  end

  def caveats
    <<~EOS
      To use the VS Code debugger, install the extension:
        code --install-extension #{prefix}/*.vsix
      Or search for "intercal64" in the VS Code extension marketplace.

      Sample programs are in:
        #{share}/intercal64/samples/

      Try:
        cd #{share}/intercal64/samples
        churn hello.i
        ./hello

      Questions, bugs, or did it actually work? Tell us on Discord:
        https://discord.gg/3jQYdBvUwz
    EOS
  end

  test do
    (testpath/"test.i").write("DO READ OUT #42\nPLEASE GIVE UP\n")
    system bin/"churn", "test.i", "-b"
    assert_predicate testpath/"test.exe", :exist?
  end
end
