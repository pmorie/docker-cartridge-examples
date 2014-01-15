#!/bin/env ruby

require 'fileutils'
require 'safe_yaml'
require 'tmpdir'

module OpenShift
  class Runner
    def initialize(login, app_name, manifest_path)
      @login = login
      @app_name = app_name
      @manifest_path = manifest_path
    end

    def run
      parsed_manifest = YAML.safe_load_file(@manifest_path, safe: true)
      manifest_endpoints = parsed_manifest['Endpoints']
      manifest_ports = []
      manifest_endpoints.each do |endpoint|
        manifest_ports << endpoint['Port']
      end

      puts "Running container #{@login}/#{@app_name}:"
      parsed_ports = parse_ports(manifest_ports)

      cmd("docker run -i #{parsed_ports} -t #{@login}/#{@app_name} &")
    end

    def cmd(cmd)
      puts "Running #{cmd}"
      system cmd
    end

    def parse_ports(ports)
      ports.map { |x| "-p #{x}" }.join(" ")
    end
             end
end

login = ARGV[0]
app_name = ARGV[1]
manifest_path = ARGV[2]

unless (login && app_name && manifest_path)
  puts "usage: run.rb <login> <app_name> <manifest_path>"
  exit -1
end

runner = OpenShift::Runner.new(login, app_name, manifest_path)
runner.run
