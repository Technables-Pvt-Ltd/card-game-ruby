require 'ostruct'

class OpenStruct
    def initialize(hash = nil)
      @table = {}
      if hash
        hash.each_pair do |k, v|
          k = k.to_sym
          @table[k] = v.is_a?(Hash) ? OpenStruct.new(v) : v
        end
      end
    end
  
    def method_missing(mid, *args) # :nodoc:
      len = args.length
      if mname = mid[/.*(?==\z)/m]
        if len != 1
          raise ArgumentError, "wrong number of arguments (#{len} for 1)", caller(1)
        end
        modifiable?[new_ostruct_member!(mname)] = args[0].is_a?(Hash) ? OpenStruct.new(args[0]) : args[0]
      elsif len == 0 # and /\A[a-z_]\w*\z/ =~ mid #
        if @table.key?(mid)
          new_ostruct_member!(mid) unless frozen?
          @table[mid]
        end
      else
        begin
          super
        rescue NoMethodError => err
          err.backtrace.shift
          raise
        end
      end
    end
  end