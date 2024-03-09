# frozen_string_literal: true

require "ffi"

require_relative "iokit/version"

module FFI
  module Library
    def define(name, value)
      define_singleton_method(name) { value }
    end
  end
end

# This module is a wrapper for a subset of the IOKit framework.
module Iokit
  class Error < StandardError; end

  extend FFI::Library

  ffi_lib "/System/Library/Frameworks/IOKit.framework/IOKit"

  # rubocop:disable Layout/LineLength, Style/SymbolArray
  typedef :uint32,      :mach_port_t
  typedef :mach_port_t, :io_object_t
  typedef :io_object_t, :io_registry_entry_t
  typedef :int,         :kern_return_t
  typedef :uint32,      :IOOptionBits
  typedef :string,      :io_name_t

  attach_variable :kIOMasterPortDefault, :mach_port_t

  define :kIOUSBPlane, "IOUSB"

  enum :io_option_bits, [:kIORegistryIterateRecursively, 0x00000001,
                         :kIORegistryIterateParents,     0x00000002]

  class IOUSBDevRequest < FFI::Struct
    layout :bmRequestType, :uint8,
           :bRequest,      :uint8,
           :wValue,        :uint16,
           :wIndex,        :uint16,
           :wLength,       :uint16,
           :pData,         :pointer,
           :wLenDone,      :uint32
  end

  attach_function :IORegistryGetRootEntry, [:mach_port_t], :io_registry_entry_t
  attach_function :IORegistryEntryCreateIterator, [:io_registry_entry_t, :io_name_t, :IOOptionBits, :pointer], :kern_return_t
  # rubocop:enable Layout/LineLength, Style/SymbolArray
end
