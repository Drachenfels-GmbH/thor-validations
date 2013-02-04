require 'thor'
require "thor-validations/version"

class Thor
  class Argument
    def process_validations!(value)
      if ! @validations.nil?
        @validations.each_pair do |message, validation|
          process_validation!(value, message, validation)
        end
      end
    end

    def process_validation!(value, message, validation)
      validation_result = nil
      if validation.respond_to?(:call)
        validation_result = validation.call(value)
      elsif validation.respond_to?(:=~)
        validation_result = (validation =~ value)
      end
      if validation_result.nil? || (validation_result == false)
        STDERR.puts "Invalid value \"#{value}\" for option:\n  --#{name} #{@banner} #{@description}\n  Message: #{message}"
        # TODO print task usage
        exit(1)
      end
    end
  end

  class Task
    alias _run run

    def run(instance, args=[])
      validate_options!(instance)
      _run(instance, args)
    end

    def validate_options!(instance)
      options.each_pair do |name, option|
        value =  instance.options[name]
        option.process_validations!(value)
      end
    end
  end

  class << self
    attr_accessor :method_params

    def method_param(name, options)
      @method_params ||= {}
      @method_params[name] = options
    end

    alias param method_param

    # create aliases to methods that are overwritten
    alias _create_task create_task
    alias _method_option method_option

    def add_validations(name, validations)
      method_options[name].instance_variable_set(:@validations, validations)
    end

    def method_option(name, options={})
      _method_option(name, options)
      if ! options[:validations].nil?
        add_validations(name, options[:validations])
      end
    end

    # redefine alias
    alias option method_option
  end
end
