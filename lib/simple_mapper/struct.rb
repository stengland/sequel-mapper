module SimpleMapper
  class Struct < ::Struct
    def initialize(args={})
      args.each { |k,v| self[k] = v }
    end
  end
end
