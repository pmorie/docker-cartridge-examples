#!/bin/env ruby

require 'fileutils'
require 'safe_yaml'

module OpenShift
  class Preparer
    def initialize(login, app_name, manifest_path, repo_path)
      @login = login
      @app_name = app_name
      @manifest_path = manifest_path
      @repo_path = repo_path
    end

    def prepare
      parsed_manifest = YAML.safe_load_file(@manifest_path, safe: true)
      base_image = parsed_manifest['Base']
      repo_mount = parsed_manifest['Volumes']['Prepare']['Location'] || '/tmp/repo'
      prepare_command = parsed_manifest['Prepare']
      execute_command = parsed_manifest['Execute']
      execute_args = parsed_manifest['Execute-Args']
      manifest_endpoints = parsed_manifest['Endpoints']
      manifest_ports = []
      manifest_endpoints.each do |endpoint|
        manifest_ports << endpoint['Port']
      end

      manifest_working_dir = parsed_manifest['Working-Dir'] || '/opt/openshift'

      FileUtils.rm_f('built_cid')

      puts "Prepare: Starting container from #{base_image} with \"#{prepare_command}\""

      cmd("docker run -cidfile built_cid -i -v #{@repo_path}:#{repo_mount}:ro #{base_image} #{prepare_command} 2>&1")

      if $? != 0
        puts "Prepare: Error starting cartridge image"
      	exit -1
      end

      container_id = IO.read('built_cid')

      puts "Prepare: Committing changes to #{@login}/#{@app_name}"
      parsed_args = parse_args(execute_args)
      parsed_ports = parse_ports(manifest_ports)

      cmd("docker commit -run='{\"WorkingDir\": \"#{manifest_working_dir}\", \"Cmd\": [\"#{execute_command}\", #{parsed_args}], \"PortSpecs\": [#{parsed_ports}]}' #{container_id} #{@login}/#{@app_name}")

      if $? != 0
      	puts "Prepare: Error committing image"
      	exit -1
      end

      puts "Prepare: image committed; will run with: \"#{execute_command} #{execute_args}\""
    end

    def cmd(cmd)
      output = `#{cmd}`
      puts "=====\n#{output}\n=====" unless output.empty?
    end

    def parse_args(args)
      args.split(" ").map { |x| "\"#{x}\"" }.join(",")
    end

    def parse_ports(ports)
      ports.map { |x| "\"#{x}\"" }.join(",")
    end
  end
end

login = ARGV[0]
app_name = ARGV[1]
manifest_path = ARGV[2]
repo_path = ARGV[3]

unless (login && app_name && manifest_path && repo_path)
  puts "usage: prepare <login> <app_name> <manifest_path> <repo_path>"
  exit -1
end

preparer = OpenShift::Preparer.new(login, app_name, manifest_path, repo_path)
preparer.prepare
