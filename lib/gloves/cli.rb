require 'gli'

module Gloves
  module Cli
    class << self
      # Need gem name for querying the gemspec
      # to get info for the top command `gloves help`
      GLOVES_LIB_NAME = 'gloves-core'

      # use regexp for searching installed modules through Gem::Specification
      GLOVES_MODULES_MATCH = /^(gloves-(?!core).\S+)/

      # For command searching in paths of installed modules
      GLOVES_COMMANDS_PATH = 'gloves/cli/commands'

      attr_reader :spec
      attr_reader :modules
      attr_reader :commands

      def start cli_argv
        @spec    = Gem::Specification.find_by_name GLOVES_LIB_NAME
        @commands = {}
        load_modules
        load_commands
        load_gli cli_argv
      end

      def command options={}
        raise ArgumentError, "Expecting both name and description" \
          unless options[:name] or options[:description]
        @commands[options[:name]] = {:description => options[:description] }
      end

      private

      # Loads all installed Gloves modules
      # In case multiple versions of modules are installed
      # only the latest version will be used
      def load_modules
        @modules = {}
        all_modules = Gem::Specification.select {|gem| gem.name =~ GLOVES_MODULES_MATCH }
        all_modules.group_by(:name).map do |name, modules_specs|
          @modules[name] = modules_specs.sort.last
        end
      end

      # Used for searching installed modules' commands using Gem::Specification#lib_dirs_glob
      def load_commands
        @commands = {}
        modules.values.each do |module_spec|
          module_spec.lib_dirs_glob.each do |module_lib_dir|
            commands_path = File.join module_lib_dir, GLOVES_COMMANDS_PATH
            Dir.entries(commands_path).grep(/\w+/).each do |command_file|
              @commands[File.basename command_file, '.rb'] = commands_path + command_file
            end
          end
        end
      end


      def start_gli_app argv
        App.gli do
          program_desc spec.description
          version Gloves::Core::VERSION
          commands.each_pair do |command_name,properties|
            command command_name do |c|
              c.action do |global,options,args|
                require "#{properties[:command_path]}"
              end
              c.description 'Loaded description from the file'
            end
          end
          quit_gli_app run(ARGV)
        end
      end

      def quit_gli_app exit_code
        if exit_code == 0
          exit exit_code
        else
          # do something else
        end
      end
    end # class << self

    module App
      def gli
        yield GLI::App if block_given?
      end

      def commands
      end
    end
  end
end
