#!/bin/env ruby

require 'fileutils'
require 'safe_yaml'
require 'tmpdir'

module OpenShift
  class Runner
    def initialize(login, app_name, manifest_path, persistent_volume_path)
      @login = login
      @app_name = app_name
      @manifest_path = manifest_path
      @persistent_volume_path = persistent_volume_path
    end

    def run
      parsed_manifest = YAML.safe_load_file(@manifest_path, safe: true)
      user = parsed_manifest['User']
      has_persistent = parsed_manifest['Volumes'].has_key? 'Persistent'

      if has_persistent && @persistent_volume_path.nil?
        puts "This image requires a persistent volume path to be supplied"
      end

      manifest_endpoints = parsed_manifest['Endpoints']
      manifest_ports = []
      manifest_endpoints.each do |endpoint|
        manifest_ports << endpoint['Port']
      end

      puts "Running container #{@login}/#{@app_name}:"
      parsed_ports = parse_ports(manifest_ports)
      mount_fragment = mount_cmd_fragment(parsed_manifest, @persistent_volume_path)

      cmd("docker run -u #{user}#{mount_fragment} -i #{parsed_ports} -t #{@login}/#{@app_name}")
    end

    def cmd(cmd)
      puts "Running #{cmd}"
      system cmd
    end

    def parse_ports(ports)
      ports.map { |x| "-p #{x}" }.join(" ")
    end

    def mount_cmd_fragment(parsed_manifest, persistent_volume)
      if persistent_volume.nil?
        ''
      else
        " -v #{persistent_volume}:#{parsed_manifest['Volumes']['Persistent']['Location']}:rw"
      end
    end
  end
end

login = ARGV[0]
app_name = ARGV[1]
manifest_path = ARGV[2]
persistent_volume_path = (ARGV.length > 3) ? ARGV[3] : nil

unless (login && app_name && manifest_path)
  puts "usage: run.rb <login> <app_name> <manifest_path> <optional: persistent_volume_path>"
  exit -1
end

runner = OpenShift::Runner.new(login, app_name, manifest_path, persistent_volume_path)
runner.run
