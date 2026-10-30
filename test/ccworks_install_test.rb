# typed: strict
# frozen_string_literal: true

# Exercise the actual install method with already-fetched wheel resources.
# Fetching again inside the macOS sandbox attempts to acquire a forbidden lock.
require "tmpdir"

# Fixtures for exercising the real formula install method without a sandbox.
module CcworksInstallTest
  # A resource already downloaded before the sandbox starts.
  class CachedWheel
    attr_reader :url, :cached_download

    def initialize(directory, name)
      @url = "https://example.invalid/#{name}-1.0-py3-none-any.whl"
      @cached_download = directory/"cached-#{name}.whl"
      @cached_download.write("fixture")
    end

    def fetch
      raise "A pre-fetched resource was fetched again inside the install sandbox"
    end
  end

  # A formula context that records offline installation commands.
  class InstallContext
    attr_reader :commands, :linked, :pure_resources

    def initialize(directory)
      @directory = directory
      @commands = []
      @linked = false
    end

    def libexec = @directory/"libexec"
    def buildpath = @directory

    def virtualenv_create(*) = self

    def resource(name)
      @resources ||= {}
      @resources[name] ||= CachedWheel.new(@directory, name)
    end

    def pip_install(resources)
      @pure_resources = resources
    end

    def pip_install_and_link(package, build_isolation:)
      raise "Wrong package or build isolation" if package != buildpath || build_isolation

      @linked = true
    end

    def ln_s(source, destination)
      File.symlink(source, destination)
    end

    def system(*command)
      @commands << command
    end
  end
end

formula = (Pathname(__dir__).parent/"Formula/ccworks.rb").read
method_source = formula[/^  def install\n.*?(?=^  def caveats\n)/m]
raise "Install method missing" unless method_source

CcworksInstallTest::InstallContext.class_eval(method_source, __FILE__)
Dir.mktmpdir("ccworks-install-test") do |temporary|
  context = CcworksInstallTest::InstallContext.new(Pathname(temporary))
  context.install
  raise "Both platform wheels must be installed" if context.commands.length != 2
  raise "Package must be linked" unless context.linked
  raise "Pure dependencies must be installed" if context.pure_resources.length != 13

  context.commands.each do |command|
    raise "Missing offline dependency guard" unless command.include?("--no-deps")
    raise "Wheel not linked to its original filename" unless Pathname(command.last).symlink?
  end
end
puts "PASS: prefetched wheels install offline without sandbox resource locks"
