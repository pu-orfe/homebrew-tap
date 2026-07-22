# pu-orfe/homebrew-tap

Homebrew formulae maintained by [Princeton ORFE](https://github.com/pu-orfe).

## Install

```bash
brew tap pu-orfe/tap
brew install <formula>
```

Or in a `Brewfile`:

```ruby
tap "pu-orfe/tap"
brew "<formula>"
```

## Formulae

| Formula | Description | Source |
| --- | --- | --- |
| [`ccworks`](./Formula/ccworks.rb) | SAP Concur browser-automation & API helper | https://github.com/pu-orfe/ccworks |

## Development

Formulae are installed and tested locally with:

```bash
brew install --build-from-source pu-orfe/tap/<formula>
brew test pu-orfe/tap/<formula>
brew audit --strict pu-orfe/tap/<formula>
```

Updating a formula for a new upstream release:

1. Bump `url` and `sha256` in the formula (get the sha with
   `curl -sL <url> | shasum -a 256`).
2. Refresh Python resource blocks if runtime pins change — the wheel URLs
   under `resource "…"` come from `pypi.org/pypi/<name>/<version>/json`.
3. Reinstall locally to verify: `brew reinstall --build-from-source pu-orfe/tap/<formula>`.
