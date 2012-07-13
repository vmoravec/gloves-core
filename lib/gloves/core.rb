require 'gloves/core/version.rb'

module Gloves
  module Core
    MODULE_NAME = ancestors.first.to_s.split('::').last
  end
end
