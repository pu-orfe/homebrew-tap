class MeetCli < Formula
  include Language::Python::Virtualenv

  desc "Companion CLI for the meet guest-speaker booking app"
  homepage "https://github.com/pu-orfe/meet"
  # meet-cli lives in the cli/ subdirectory of the pu-orfe/meet monorepo, so
  # there is no per-CLI release archive; the repo is also private, which rules
  # out ccworks.rb's unauthenticated `archive/refs/tags/vX.Y.Z.tar.gz` + sha256
  # pattern (that download 404s without credentials, whereas a git clone picks
  # up the user's existing git auth). Pin a tag rather than a branch: this
  # previously tracked the cli-companion-phase1 feature branch, which vanished
  # when it merged and broke `brew install` outright.
  url "https://github.com/pu-orfe/meet.git",
      tag:      "meet-cli-v0.1.4",
      revision: "0511db97ed1d773f17ebe365eecc4e932da3d6ad"
  license "MIT"

  depends_on "python@3.12"

  # --- build backend for meet-cli itself (hatchling) ---
  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/08/e7/ae38d7a6dfba0533684e0b2136817d667588ae3ec984c1a4e5df5eb88482/hatchling-1.27.0-py3-none-any.whl"
    sha256 "d3a2f3567c4f926ea39849cdf924c7e99e6686c9c8e288ae1037c8fa2a5d937b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/88/ef/eb23f262cca3c0c4eb7ab1933c3b1f03d021f2c48f54763065b6f0e321be/packaging-24.2-py3-none-any.whl"
    sha256 "09abb1bccd265c01f4a3aa3f7a7db064b36514d2cba19a2f694fe6150451a759"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/cc/20/ff623b09d963f88bfde16306a54e12ee5ea43e9b597108672ff3a408aad6/pathspec-0.12.1-py3-none-any.whl"
    sha256 "a0d503e138a4c123b27490a4f7beda6a01c6f288df0e4a8b79c7eb0dc7b4cc08"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/88/5f/e351af9a41f866ac3f1fac4ca0613908d9a41741cfcf2228f4ad853b697d/pluggy-1.5.0-py3-none-any.whl"
    sha256 "44e1ad92c8ca002de6377e165f3e0f1be63266ab4d554740532335b9d75ea669"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/2b/c5/6422dbc59954389b20b2aba85b737ab4a552e357e7ea14b52f40312e7c84/trove_classifiers-2025.1.15.22-py3-none-any.whl"
    sha256 "5f19c789d4f17f501d36c94dbbf969fb3e8c2784d008e6f5164dd2c3d6a2b07c"
  end

  # --- meet-cli runtime dependencies (all pure python, no compiled wheels) ---
  resource "click" do
    url "https://files.pythonhosted.org/packages/fb/e2/79c688af8b210d232694e31e59da9f6ec747bae31c3f5946e4e9b98860d5/click-8.4.2-py3-none-any.whl"
    sha256 "e6f9f66136c816745b9d65817da91d61d957fb16e02e4dcd0552553c5a197b76"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a0/f4/c67b0b3f1b9245e8d266f0f112c500d50e5b4e83cb6f3b71b6528104182a/requests-2.34.2-py3-none-any.whl"
    sha256 "2a0d60c172f83ac6ab31e4554906c0f3b3588d37b5cb939b1c061f4907e278e0"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/0b/a7/71ac2cff56fec219ed242bb11b8efb69fcc4bec75db06fb7bfe35de520e6/certifi-2026.7.22-py3-none-any.whl"
    sha256 "62f22742b58a1a33014a2b6b706588a8d7e2a88ae7bd1a6ebe8c992928483775"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/98/2b/f97f1c193fb855c345d678f5077d6926034db0722df74c8f057020e05a25/charset_normalizer-3.4.9-py3-none-any.whl"
    sha256 "68e5f26a1ad57ded6d1cfb85331d1c1a195314756471d97758c48498bb4dcdf5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/1e/5e/d4e9f1a599fb8e573b7b87160658329fbf28d19eac2718f51fc3def3aa5a/idna-3.18-py3-none-any.whl"
    sha256 "7f952cbe720b688055e3f87de14f5c3e5fdaa8bc3928985c4077ca689de849a2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7f/3e/5db95bcf282c52709639744ca2a8b149baccf648e39c8cc87553df9eae0c/urllib3-2.7.0-py3-none-any.whl"
    sha256 "9fb4c81ebbb1ce9531cce37674bbc6f1360472bc18ca9a553ede278ef7276897"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12", system_site_packages: true, without_pip: true)

    venv.pip_install [
      resource("hatchling"), resource("packaging"), resource("pathspec"),
      resource("pluggy"), resource("trove-classifiers"),
      resource("click"), resource("certifi"), resource("charset-normalizer"),
      resource("idna"), resource("urllib3"), resource("requests")
    ]

    # meet-cli itself lives in the cli/ subdirectory of this monorepo checkout.
    venv.pip_install_and_link buildpath/"cli", build_isolation: false
  end

  test do
    assert_equal "meet, version #{version}", shell_output("#{bin}/meet --version").strip

    output = shell_output("#{bin}/meet --help")
    assert_match "Usage: meet", output
    assert_match "agenda-link", output

    usage = shell_output("#{bin}/meet 2>&1", 2)
    assert_match "Usage: meet", usage
  end
end
