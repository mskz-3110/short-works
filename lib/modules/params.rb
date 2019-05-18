module ShortWorks
  module Params
    def self.get( params, key, default_value, &block )
      value = params.key?( key ) ? params[ key ] : default_value
      value = block.call( value ) if block_given?
      value
    end
  end
end
