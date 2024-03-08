# frozen_string_literal: true

require "ffi"

require_relative "iokit/version"

# This module is a wrapper for a subset of the IOKit framework.
module Iokit
  class Error < StandardError; end
end
