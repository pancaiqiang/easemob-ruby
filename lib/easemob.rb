require 'easemob/version'
require 'easemob/configuration'
require 'easemob/client'

module Easemob
  class << self
    def configuration
      @configuration ||=  Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end
  end

  module_function

  # Return the root path of this gem.
  #
  # @return [String] Path of the gem's root.
  def root
    File.dirname __dir__
  end

  # Return the lib path of this gem.
  #
  # @return [String] Path of the gem's lib.
  def lib
    File.join root, 'lib'
  end

  # Return the spec path of this gem.
  #
  # @return [String] Path of the gem's spec.
  def spec
    File.join root, 'spec'
  end
end
