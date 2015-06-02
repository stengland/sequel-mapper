module SimpleMapper
  class Struct < ::Struct
    def initialize(args={})
      args.each { |k,v| self[k] = v if members.include?(k.to_sym) }
    end

    def slice(*keys)
      keys.reduce({}) do |hash, key|
        hash[key] = self[key]
        hash
      end
    end
  end
end
