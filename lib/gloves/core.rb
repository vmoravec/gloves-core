require 'gloves/core/version.rb'

module Gloves
  module Core ; end

  #TODO load from a yaml or json config file or put here just in plain hash
  ALL_MODULES = {
    :name=>'timezone',:desc=>'Timezone configuration',:pkg=>'gloves-timezone'
  }
end
