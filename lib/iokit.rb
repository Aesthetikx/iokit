# frozen_string_literal: true

require "ffi"

require_relative "iokit/version"

# This module is a wrapper for a subset of the IOKit framework.
module Iokit
  class Error < StandardError; end

  extend FFI::Library

  ffi_lib "/System/Library/Frameworks/IOKit.framework/IOKit"

  # rubocop:disable Style/Documentation
  class IOUSBDevRequest < FFI::Struct
    layout :bmRequestType, :uint8,
           :bRequest,      :uint8,
           :wValue,        :uint16,
           :wIndex,        :uint16,
           :wLength,       :uint16,
           :pData,         :pointer,
           :wLenDone,      :uint32
  end

  typedef :uint32,      :mach_port_t
  typedef :mach_port_t, :io_object_t
  typedef :io_object_t, :io_registry_entry_t

  attach_variable :kIOMasterPortDefault, :mach_port_t

  attach_function :IORegistryGetRootEntry, [:mach_port_t], :io_registry_entry_t
  # rubocop:enable Style/Documentation
end
