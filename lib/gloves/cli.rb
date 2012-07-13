require 'gloves/core'
require 'gli'

module Gloves
  LIB_NAME = 'gloves'

  module Cli
    class << self
      # use regexp for searching installed modules through Gem::Specification
      GLOVES_MODULES_MATCH = /^(#{Gloves::LIB_NAME}-(?!#{Gloves::Core::MODULE_NAME}).\S+)/

      # For command searching in paths of installed modules
      GLOVES_COMMANDS_PATH = 'gloves/cli/commands'

      attr_reader :spec
      attr_reader :modules
      attr_reader :commands

      def start argv
        @commands = {}
        @modules  = {}
        @spec     = Gem::Specification.find_by_name GLOVES_LIB_NAME
        load_modules
        load_commands
        load_gli argv
      end

      def command options={}, &block
        command_name = options.delete :name
        command_desc = options[:description]
        raise ArgumentError, "Expecting both command name and description" \
          unless command_name && command_desc
        raise RuntimeError, "Duplicate definition of command #{command_name} in #{caller[0]}" +
          "There already exists a command '#{command_name}' in #{@commands[command_name][:block].source_location}" \
          if @commands[command_name]
        @commands[command_name] = options.update :block=>block
      end

      private

      # Loads all installed Gloves modules
      # In case multiple versions of modules are installed
      # only the latest version will be used
      def load_modules
        all_modules = Gem::Specification.select {|gem| gem.name =~ GLOVES_MODULES_MATCH }
        all_modules.group_by(:name).map do |name, modules_specs|
          @modules[name] = modules_specs.sort.last
        end
      end

      # Used for searching installed modules' commands using Gem::Specification#lib_dirs_glob
      def load_commands
        modules.values.each do |module_spec|
          module_spec.lib_dirs_glob.each do |module_lib_dir|
            commands_path = File.join module_lib_dir, GLOVES_COMMANDS_PATH
            Dir.entries(commands_path).grep(/\w+/).each do |command_file|
              # @commands[File.basename command_file, '.rb'] = commands_path + command_file
              require commands_path + command_file
            end
          end
        end
      end


      def start_gli_app argv
        App.gli do
          #TODO create separate file with top command specs
          program_desc spec.description
          version Gloves::Core::VERSION
          commands.each_pair do |command_name,properties|
            command command_name &properties[:block]
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
      def self.gli
        yield GLI::App if block_given?
      end

      def commands
      end
    end
  end
end
