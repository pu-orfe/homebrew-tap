class Ccworks < Formula
  include Language::Python::Virtualenv

  desc "SAP Concur browser-automation and API helper"
  homepage "https://github.com/pu-shd/ccworks"
  url "https://github.com/pu-shd/ccworks/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "9dc9bb60d25d925073880641feed8dd95dec7140004dc1ad33f3fff35436d7ad"
  license "MIT"

  depends_on "python@3.12"

  # Homebrew's install sandbox blocks pip's outbound network, so every dep
  # (including build backends) is pinned as a wheel resource. Only greenlet
  # and playwright have platform-specific wheels; everything else is pure
  # Python (py3-none-any) and installs directly via `venv.pip_install`.

  # --- Build backend for ccworks itself (hatchling) ---
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

  # --- ccworks runtime dependencies ---
  resource "certifi" do
    url "https://files.pythonhosted.org/packages/32/d1/a3652fe2c19134d0d15922177821d863cbd7e842d53a21bbe7e8e3a1b5ac/certifi-2026.10.23-py3-none-any.whl"
    sha256 "e9b54de76e530bb6cf0ccd036787103acb58fd42ba930ea8bf948ddbaa2f61d1"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/fc/ad/d07d7862a62ffa6d79d68074d14823243dd235a77c45262acbf6adeb28bf/charset_normalizer-3.5.2-py3-none-any.whl"
    sha256 "b6b751274acb69d77b3323d6b7dbaa3c7fdfc1eb829b7eb61d262f32e1af9685"
  end

  # greenlet has C extensions — per (OS, arch) wheel keyed to cp312.
  resource "greenlet" do
    on_macos do
      url "https://files.pythonhosted.org/packages/72/18/3fc6d951466ae9a2a688edcddde3b2e388da0a8244e0caf7117bbeb0eb95/greenlet-3.5.6-cp312-cp312-macosx_11_0_universal2.whl"
      sha256 "a5876d0a60355af98d535c47f6cd6eb0f8a432396dab26845d380b92f8412422"
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/27/89/366d2af5061eeefa5012f510d95a99c8620dcc457609838db4d538820318/greenlet-3.5.6-cp312-cp312-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl"
        sha256 "e85880b538e59a59f55117b81f208a6660ad5ac328aad9305f812d9b8bc67a0f"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/66/6a/1594f3869c57c149abdb380492529e04d4c0229b5e4d79572c5bd0aaa673/greenlet-3.5.6-cp312-cp312-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl"
        sha256 "975736b002ed080d124cf81a79cb7e05cb26d6b3f5c7a7b651c0fcce70353aa1"
      end
    end
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/58/a2/bb081bab032533a855d44de1d56f8e8426114ff1ba5d1f07a438a0a654f8/idna-3.20-py3-none-any.whl"
    sha256 "ab7ae7122974553370f0bdb919e1a960b2cd1bc1ef0276416d896db81c14582c"
  end

  # playwright ships wheels only (bundled node driver binary is per-OS/arch).
  resource "playwright" do
    on_macos do
      on_arm do
        url "https://files.pythonhosted.org/packages/72/4f/572bbbe60a5787ca61a84bad934c3ce19c08c2bc9c0e9781bf0d99cad1a6/playwright-1.64.1-py3-none-macosx_11_0_arm64.whl"
        sha256 "59f7b041284ce8d1b72098ae50ca48a2d83692eec25154ab5ba79d4b6b4fe8a9"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/8d/c8/cc677856d89a0c077673b40ab915ed5597bf1347b205cabe70121c431ca9/playwright-1.64.1-py3-none-macosx_10_13_x86_64.whl"
        sha256 "29453ff76e25c17d0b45658cacd6b92e9eec46e8db21e134fb3b7143df50f013"
      end
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/0c/11/545f25e47ec54e1e8a2892ef9994fc2b298f909ab37b88578e3a1f87ac2e/playwright-1.64.1-py3-none-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
        sha256 "a29fda44725e11b0b625c4bff6458a1f6dbee97b88c9788d12e18a8344458c2d"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/15/b9/e481a34572933b5cf179d5637c98da488c732ee339dff5b73a0624d2e42b/playwright-1.64.1-py3-none-manylinux1_x86_64.whl"
        sha256 "577b8d88778c245cfbd145ae17cf53044f084b1b46c55c69081d4069d56057e2"
      end
    end
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/a0/c4/b4d4827c93ef43c01f599ef31453ccc1c132b353284fc6c87d535c233129/pyee-13.0.1-py3-none-any.whl"
    sha256 "af2f8fede4171ef667dfded53f96e2ed0d6e6bd7ee3bb46437f77e3b57689228"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/60/d1/38f3a3405989a89ac18390803e70c6ad7c7760da4f9b83cbeca0c44a0c72/python_dotenv-1.2.4-py3-none-any.whl"
    sha256 "42269a8a5b3fd54ffa6f3d84b18abed50064717576b4ecf03dc4a55d8aa04fdc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a0/f4/c67b0b3f1b9245e8d266f0f112c500d50e5b4e83cb6f3b71b6528104182a/requests-2.34.2-py3-none-any.whl"
    sha256 "2a0d60c172f83ac6ab31e4554906c0f3b3588d37b5cb939b1c061f4907e278e0"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/49/d3/b8441a820a491ddfc024b0b0cf0393375b75ea13866d9c66727e54c2fc80/typing_extensions-4.16.0-py3-none-any.whl"
    sha256 "481caa481374e813c1b176ada14e97f1f67a4539ce9cfeb3f350d78d6370c2e8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/92/9d/c4e665119135114480843e7ab388fa94d8480650450e6f8e26b70d323a4c/urllib3-2.8.0-py3-none-any.whl"
    sha256 "0cf3cae568d36aa9576b28dfb35f11328f1cb974ca7647d9475ebb86c75ac6e3"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12", system_site_packages: true, without_pip: true)

    # Pure-python resources go through the standard helper, which handles
    # py3-none-any wheels natively.
    pure_resources = %w[
      hatchling packaging pathspec pluggy trove-classifiers
      certifi charset-normalizer idna pyee python-dotenv requests
      typing-extensions urllib3
    ]
    venv.pip_install pure_resources.map { |name| resource(name) }

    # Platform-specific wheels (greenlet, playwright) don't match brew's
    # `py3-none-any.whl` fast path — install them by wheel-file path.
    # Brew's cache prepends a hash to the filename; pip rejects that as a
    # malformed wheel name, so we link the download to its original basename
    # inside a scratch dir before invoking pip.
    scratch = buildpath/"platform-wheels"
    scratch.mkpath
    %w[greenlet playwright].each do |name|
      r = resource(name)
      r.fetch
      wheel = scratch/File.basename(r.url)
      wheel.unlink if wheel.symlink? || wheel.exist?
      ln_s r.cached_download, wheel
      system libexec/"bin/python", "-m", "pip", "install", "--no-deps",
             "--no-build-isolation", "--disable-pip-version-check",
             wheel.to_s
    end

    # Finally install ccworks itself; hatchling is now available in the venv.
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  def caveats
    <<~EOS
      On the first browser command, ccworks will download Playwright's chromium
      browser (~180 MB) into ~/Library/Caches/ms-playwright. Set
      CCWORKS_SKIP_BROWSER_BOOTSTRAP=1 if you manage that binary yourself.

      Session state (login cookies, screenshots) is written to
      ~/Library/Application Support/ccworks; override with CCWORKS_STATE_DIR.

      Put your Concur credentials in a .env file in the directory you invoke
      ccworks from (see .env.example in the source repo).
    EOS
  end

  test do
    # The built artifact must report the version this formula claims. Catches a
    # url/sha/version mismatch, which has happened: v0.1.1 shipped while the
    # package metadata still said 0.1.0.
    assert_equal "ccworks #{version}", shell_output("#{bin}/ccworks --version").strip

    # A bare invocation prints the grouped command reference and exits 0.
    # (This asserted exit 2 previously, which never matched the shipped CLI.)
    output = shell_output("#{bin}/ccworks 2>&1")
    assert_match "usage:", output
    assert_match "report list", output

    bulk_help = shell_output("#{bin}/ccworks txn allocate-bulk --help")
    assert_match "--dry-run", bulk_help
    assert_match "--indices", bulk_help

    # Retired flat names exit 2 and name their replacement.
    legacy = shell_output("#{bin}/ccworks query-old 2>&1", 2)
    assert_match "report list --historical", legacy
  end
end
