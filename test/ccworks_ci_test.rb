# typed: strict
# frozen_string_literal: true

# Exercise the actual verification script against success and false-green cases.
require "open3"
require "psych"
require "tmpdir"

workflow = Psych.load_file((Pathname(__dir__).parent/".github/workflows/tests.yml").to_s)
job = workflow.fetch("jobs").fetch("test-bot")
raise "Container scripts require an explicit Bash shell" if job.dig("defaults", "run", "shell") != "bash"

job.fetch("steps").each do |item|
  next unless item["run"]

  expected_directory = "${{ steps.set-up-homebrew.outputs.repository-path }}"
  raise "Run steps must use Homebrew's actual checkout" if item["working-directory"] != expected_directory
end

step = job.fetch("steps").find { |item| item["name"] == "Verify ccworks source install and bottle" }
raise "Required verification step missing" unless step

Dir.mktmpdir("ccworks-ci-test") do |temporary|
  directory = Pathname(temporary)
  bin = directory/"bin"
  bin.mkpath
  (directory/"verify.sh").write(step.fetch("run"))
  (bin/"brew").write(<<~SH)
    #!/bin/bash
    set -euo pipefail
    printf '%s\n' "$*" >> "$TEST_CALLS"
    case "$1" in
      deps) printf '%s\n' 'openssl@3' 'python@3.12' ;;
      list) exit 1 ;;
      install)
        if [[ "$TEST_SCENARIO" == "install_failure" ]]; then exit 17; fi
        if [[ "$TEST_SCENARIO" == "intel_dependency_failure" && "$*" == *--build-from-source* ]]; then exit 19; fi ;;
      test) if [[ "$TEST_SCENARIO" == "test_failure" ]]; then exit 18; fi ;;
      info) printf '%s' '{"formulae":[{"versions":{"stable":"0.7.0"},"revision":1}]}' ;;
      ruby) shift; shift; exec "$TEST_RUBY" "$@" ;;
      bottle) if [[ "$TEST_SCENARIO" != "missing_bottle" ]]; then touch ccworks--0.7.0_1.fixture.bottle.json; fi ;;
      *) echo "Unexpected brew command: $1" >&2; exit 20 ;;
    esac
  SH
  (bin/"ccworks").write(<<~SH)
    #!/bin/bash
    set -euo pipefail
    if [[ "$TEST_SCENARIO" == "wrong_version" ]]; then
      echo 'ccworks 0.6.1'
    else
      echo 'ccworks 0.7.0'
    fi
  SH
  (bin/"brew").chmod(0755)
  (bin/"ccworks").chmod(0755)
  %w[success intel_success intel_dependency_failure install_failure test_failure missing_bottle
     wrong_version].each do |scenario|
    bottle = directory/"ccworks--0.7.0_1.fixture.bottle.json"
    bottle.unlink if bottle.exist?
    calls = directory/"calls.log"
    calls.write("")
    environment = { "TEST_CALLS" => calls.to_s,
                    "CCWORKS_BUILD_DEPS_FROM_SOURCE" => scenario.start_with?("intel_").to_s,
                    "PATH" => "#{bin}:#{ENV.fetch("PATH")}", "TEST_SCENARIO" => scenario,
                    "TEST_RUBY" => RbConfig.ruby }
    output, error, status = Open3.capture3(environment, "/bin/bash", (directory/"verify.sh").to_s,
                                           chdir: directory.to_s)
    expected = %w[success intel_success].include?(scenario)
    raise "#{scenario} returned an incorrect status: #{output} #{error}" if status.success? != expected
    raise "Success must be explicit" if expected && output.exclude?("PASS: ccworks source install")

    if scenario == "intel_success" && calls.read.exclude?("install --verbose --build-from-source openssl@3 python@3.12")
      raise "Intel must prebuild missing dependency bottles from source"
    end

    puts "PASS: CI verification #{scenario}"
  end
end
