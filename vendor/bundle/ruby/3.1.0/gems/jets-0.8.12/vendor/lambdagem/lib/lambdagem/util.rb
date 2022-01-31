# Can use this a few ways, examples:
#
# Directly usage:
#
#   Lambdagem::Util.say("hi")
#
# Include it in your class:
#
#   class MyClass
#     include Lambdagem::Util
#
#     def some_meth
#       say "some_meth"
#     end
#   end
#
module Lambdagem
  module Util
    @@log_level = :debug
    def log_level=(val)
      @@log_level = val
    end

    def say(message, level=:info)
      enabled = @@log_level == :debug || level == :debug
      puts(message) if enabled
    end
    extend self
  end
end
