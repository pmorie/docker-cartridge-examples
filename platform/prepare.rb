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
      manifest_command = parsed_manifest['Execute']
      manifest_args = parsed_manifest['Execute-Args']

      FileUtils.rm_f('built_cid')

      puts "Prepare: Starting container from #{base_image}"

      `docker run -cidfile built_cid -i -v #{@repo_path}:/tmp/repo:ro #{base_image}`

      if $? != 0
      	puts "Prepare: Error preparing image"
      	exit -1
      end

      container_id = IO.read('built_cid')

      puts "Prepare: Committing changes to #{@login}/#{@app_name}"
      parsed_args = parse_args(manifest_args)

      `docker commit -run='{"WorkingDir": "/opt/openshift", "Cmd": ["#{manifest_command}", #{parsed_args}], "PortSpecs": ["8080"]}' #{container_id} #{@login}/#{@app_name}`

      if $? != 0
      	puts "Prepare: Error committing image"
      	exit -1
      end

      puts "Prepare: image committed; will run with: \"#{manifest_command} #{manifest_args}\""
    end

    def parse_args(args)
      args.split(" ").map { |x| "\"#{x}\"" }.join(",")
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
