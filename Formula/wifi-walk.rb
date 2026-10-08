class WifiWalk < Formula
  desc "Interactive Wi-Fi walk test: log signal, SNR, roams and APs to CSV"
  homepage "https://github.com/pu-shd/wifi-walk"
  url "https://github.com/pu-shd/wifi-walk/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d754fb2c9e35d18166a6b40859efb5ccace320a0b5ae9db85dcb890c863346df"
  license "MIT"

  # Reads Wi-Fi state with macOS's wdutil and ipconfig.
  depends_on :macos

  def install
    bin.install "wifi-walk.sh" => "wifi-walk"
    pkgshare.install "examples"
    # The upstream test suite (wdutil, ipconfig, sudo, su and id are mocked)
    # expects wifi-walk.sh beside tests/, so ship both for `brew test`.
    pkgshare.install "tests"
    pkgshare.install_symlink bin/"wifi-walk" => "wifi-walk.sh"
  end

  def caveats
    <<~EOS
      wifi-walk needs root for wdutil. Admins are prompted by sudo; if your
      account can't sudo, use `wifi-walk -a ACCOUNT` to go through an account
      that can (su, then sudo).

      An example AP map is in:
        #{opt_pkgshare}/examples/ap-map.csv
    EOS
  end

  test do
    assert_equal "wifi-walk #{version}", shell_output("#{bin}/wifi-walk -V").strip
    assert_match "Usage: wifi-walk", shell_output("#{bin}/wifi-walk -h")
    assert_match "-p must be location, ap or both", shell_output("#{bin}/wifi-walk -p bogus 2>&1", 1)

    # Full mocked suite; it exits non-zero unless every assertion passed.
    system "zsh", pkgshare/"tests/run.zsh"
  end
end
