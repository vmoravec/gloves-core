module Gloves
  module Cli
    class << self

      GLOVES_LIB_NAME = 'gloves-core'
      GLOVES_COMMANDS_PATH = 'gloves/cli/commands'
      GLOVES_MODULES_MATCH = /(gloves-(?!core).\S+)/

      attr_reader :spec
      attr_reader :modules
      attr_reader :commands

      def start
        @spec    = Gem::Specification.find_by_name GLOVES_LIB_NAME
        @modules = Gem::Specification.select {|gem| gem.name =~ GLOVES_MODULES_MATCH }
        load_commands
        start_gli_app
      end

      def command name

      end

      private

      def load_commands
        @commands = {}
        modules.map.lib_dirs_glob.each do |module_lib_dir|
          commands_path = File.join module_lib_dir, GLOVES_COMMANDS_PATH
          module_commands = Dir.entries(commands_path).grep /\w+/
          module_commands.each do |command|
            @commands[command] = { :command_path => commands_path }
          end
        end
      end

      def start_gli_app
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
