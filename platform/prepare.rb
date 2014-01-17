#!/bin/env ruby

require 'fileutils'
require 'safe_yaml'
require 'tmpdir'

module OpenShift
  class Preparer
    def initialize(login, app_name, manifest_path, source_path)
      @login = login
      @app_name = app_name
      @manifest_path = manifest_path
      @source_path = source_path
    end

    def prepare
      parsed_manifest = YAML.safe_load_file(@manifest_path, safe: true)
      base_image = parsed_manifest['Base']
      has_build = parsed_manifest.has_key? 'Build-Image'
      repo_mount = parsed_manifest['Volumes']['Prepare']['Location'] || '/tmp/repo'
      prepare_command = parsed_manifest['Prepare']
      prepare_env_vars = parsed_manifest['Prepare-Environment'] || []
      execute_command = parsed_manifest['Execute']
      execute_args = parsed_manifest['Execute-Args']
      manifest_endpoints = parsed_manifest['Endpoints']
      manifest_ports = []
      manifest_endpoints.each do |endpoint|
        manifest_ports << endpoint['Port']
      end

      passed_prepare_env = {}

      prepare_env_vars.each do |var|
        value = ENV[var]

        unless value
          puts "Required env var #{var} is not set.  Unable to prepare gear image"
          exit -1
        end

        passed_prepare_env[var] = value
      end

      manifest_working_dir = parsed_manifest['Working-Dir'] || '/opt/openshift'
      env_cmd_fragment = prepare_envs(passed_prepare_env)
      build_mount_fragment = ' '

      if has_build
        build_image = parsed_manifest['Build-Image']
        build_mount = parsed_manifest['Volumes']['Build']['Location']
        build_command = parsed_manifest['Build']
        tmp_build_dir, build_mount_fragment = build_mount_cmd(build_mount)
        puts "Prepare: Building repo in #{build_image} with #{build_command}"
      
        cmd("docker run -i -v #{@source_path}:#{repo_mount}:ro #{build_mount_fragment}#{env_cmd_fragment} #{build_image} #{build_command} 2>&1")

        if $? != 0
          puts "Prepare: build failed"
          exit -1
        end
      end

      FileUtils.rm_f('built_cid')
      puts "Prepare: Starting container from #{base_image} with \"#{prepare_command}\""
      cmd("docker run -cidfile built_cid -i -v #{@source_path}:#{repo_mount}:ro #{build_mount_fragment}#{env_cmd_fragment} #{base_image} #{prepare_command} 2>&1")

      if $? != 0
        puts "Prepare: Error starting cartridge image"
      	exit -1
      end

      container_id = IO.read('built_cid')

      puts "Prepare: Committing changes to #{@login}/#{@app_name}"
      parsed_args = parse_args(execute_args)
      parsed_ports = parse_ports(manifest_ports)

      cmd("docker commit -run='{\"WorkingDir\": \"#{manifest_working_dir}\", \"Cmd\": [\"#{execute_command}\"#{parsed_args}], \"PortSpecs\": [#{parsed_ports}]}' #{container_id} #{@login}/#{@app_name}")

      if $? != 0
      	puts "Prepare: Error committing image"
      	exit -1
      end

      puts "Prepare: image committed; will run with: \"#{execute_command} #{execute_args}\""
    end

    def cmd(cmd)
      puts "Running #{cmd}"
      system cmd
    end

    def parse_args(args)
      if args
        ", " + args.split(" ").map { |x| "\"#{x}\"" }.join(",")
      else
        ''
      end
    end

    def prepare_envs(env)
      env.map { |k, v| "-e '#{k}=#{v}'"}.join(" ")
    end

    def parse_ports(ports)
      ports.map { |x| "\"#{x}\"" }.join(",")
    end

    def build_mount_cmd(build_mount)
      tmp_dir = Dir.mktmpdir
      return tmp_dir, " -v #{tmp_dir}:#{build_mount}:rw"
    end
  end
end

login = ARGV[0]
app_name = ARGV[1]
manifest_path = ARGV[2]
source_path = ARGV[3]

unless (login && app_name && manifest_path && source_path)
  puts "usage: prepare <login> <app_name> <manifest_path> <source_path>"
  exit -1
end

preparer = OpenShift::Preparer.new(login, app_name, manifest_path, source_path)
preparer.prepare
