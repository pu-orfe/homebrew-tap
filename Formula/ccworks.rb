class Ccworks < Formula
  include Language::Python::Virtualenv

  desc "SAP Concur browser-automation and API helper"
  homepage "https://github.com/pu-orfe/ccworks"
  url "https://github.com/pu-orfe/ccworks/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "cee8eb74476b14b3f7e4273bf2a428ea6360ae2d8f90f51b0e81537f11b8f221"
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
    url "https://files.pythonhosted.org/packages/0b/a7/71ac2cff56fec219ed242bb11b8efb69fcc4bec75db06fb7bfe35de520e6/certifi-2026.7.22-py3-none-any.whl"
    sha256 "62f22742b58a1a33014a2b6b706588a8d7e2a88ae7bd1a6ebe8c992928483775"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/98/2b/f97f1c193fb855c345d678f5077d6926034db0722df74c8f057020e05a25/charset_normalizer-3.4.9-py3-none-any.whl"
    sha256 "68e5f26a1ad57ded6d1cfb85331d1c1a195314756471d97758c48498bb4dcdf5"
  end

  # greenlet has C extensions — per (OS, arch) wheel keyed to cp312.
  resource "greenlet" do
    on_macos do
      url "https://files.pythonhosted.org/packages/f3/04/81bd731d6d1e3a469d9a4c36f5eb069bcf0cbb2d5d342c9fec22245b91fc/greenlet-3.5.4-cp312-cp312-macosx_11_0_universal2.whl"
      sha256 "3d66250e8b09f182ede05490998c818b5961f7a3640332d44c4927caec7bbfe4"
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/cc/dd/f5f22903a6ae70f5ea328ed0beaec92ad903f0e3b7d2845133b354abc4b8/greenlet-3.5.4-cp312-cp312-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl"
        sha256 "c90e930c9c192e5b3ee9fb8bcd920ea3926155e2e3ded39fc697323addecee17"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/50/6d/0b14bb9db2989f32cd9fe7f76afedea01ee8bee3f87c07e69f24adfe7e63/greenlet-3.5.4-cp312-cp312-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl"
        sha256 "f88193799d43dbf8c8a806d6405c9c52fe2af40bf75072a606357b33cc336c7f"
      end
    end
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/1e/5e/d4e9f1a599fb8e573b7b87160658329fbf28d19eac2718f51fc3def3aa5a/idna-3.18-py3-none-any.whl"
    sha256 "7f952cbe720b688055e3f87de14f5c3e5fdaa8bc3928985c4077ca689de849a2"
  end

  # playwright ships wheels only (bundled node driver binary is per-OS/arch).
  resource "playwright" do
    on_macos do
      on_arm do
        url "https://files.pythonhosted.org/packages/42/35/71395dd3ecc798965be4a3ef8c443217d4abca168e7cb34536304f9489e6/playwright-1.61.0-py3-none-macosx_11_0_arm64.whl"
        sha256 "009588c2a7e499bc5a8b425b61fa65490968bbda9cd69e0cf2cff10f8304659a"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/44/ee/31e4e0db36588b817a10b299a0285082545fde7d36543c2abe498bb3d61a/playwright-1.61.0-py3-none-macosx_10_13_x86_64.whl"
        sha256 "ff138c3a604f69911e9d42fd036e55c2a171e5616edf04c1e7f60a2a285540b0"
      end
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/b7/eb/e3f922348ec17c315f98c463f72faa1181a1c3de0bfe31a8d2edf6561723/playwright-1.61.0-py3-none-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
        sha256 "93454322ade8c11d5d6c211bfd91bdfb9ffb4810e3e026371bcbc4bec1b7ee4c"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/ab/f8/a35bf179e4ba2522c1893635094a64e407572547bd61528820fc0abc87fe/playwright-1.61.0-py3-none-manylinux1_x86_64.whl"
        sha256 "54f3b39f6eab832e33458c1dd7da0b5682aedab3b09ae731b5c59fa12fd2024e"
      end
    end
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/a0/c4/b4d4827c93ef43c01f599ef31453ccc1c132b353284fc6c87d535c233129/pyee-13.0.1-py3-none-any.whl"
    sha256 "af2f8fede4171ef667dfded53f96e2ed0d6e6bd7ee3bb46437f77e3b57689228"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/0b/d7/1959b9648791274998a9c3526f6d0ec8fd2233e4d4acce81bbae76b44b2a/python_dotenv-1.2.2-py3-none-any.whl"
    sha256 "1d8214789a24de455a8b8bd8ae6fe3c6b69a5e3d64aa8a8e5d68e694bbcb285a"
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
    url "https://files.pythonhosted.org/packages/7f/3e/5db95bcf282c52709639744ca2a8b149baccf648e39c8cc87553df9eae0c/urllib3-2.7.0-py3-none-any.whl"
    sha256 "9fb4c81ebbb1ce9531cce37674bbc6f1360472bc18ca9a553ede278ef7276897"
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
      FileUtils.ln_s(r.cached_download, wheel)
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
    output = shell_output("#{bin}/ccworks 2>&1", 2)
    assert_match "usage:", output
  end
end
