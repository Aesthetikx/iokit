# frozen_string_literal: true

require "ffi"

require "core_foundation"

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
  typedef :uint32,        :mach_port_t
  typedef :mach_port_t,   :io_object_t
  typedef :io_object_t,   :io_registry_entry_t
  typedef :io_object_t,   :io_iterator_t
  typedef :io_object_t,   :io_service_t
  typedef :int,           :kern_return_t
  typedef :kern_return_t, :IOReturn
  typedef :uint32,        :IOOptionBits
  typedef :string,        :io_name_t
  typedef :int32,         :HRESULT
  typedef :uint32,        :ULONG
  typedef :pointer,       :LPVOID
  typedef :pointer,       :cf_dictionary_ref

  cf_uuid_ref = CoreFoundation::CFUUIDBytes.by_ref

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

  class IOCFPluginInterfaceStruct < FFI::Struct
    layout :_reserved,      :pointer,
           :QueryInterface, callback([:pointer, CoreFoundation::CFUUIDBytes.by_value, :LPVOID], :HRESULT),
           :AddRef,         callback([:pointer], :ULONG),
           :Release,        callback([:pointer], :ULONG),
           :version,        :uint16,
           :revision,       :uint16,
           :Probe,          callback([:pointer, :cf_dictionary_ref, :io_service_t, :pointer], :IOReturn),
           :Start,          callback([:pointer, :cf_dictionary_ref, :io_service_t], :IOReturn),
           :Stop,           callback([:pointer], :IOReturn)
  end

  attach_function :IORegistryGetRootEntry, [:mach_port_t], :io_registry_entry_t
  attach_function :IORegistryEntryCreateIterator, [:io_registry_entry_t, :io_name_t, :IOOptionBits, :pointer], :kern_return_t
  attach_function :IOIteratorNext, [:io_iterator_t], :io_object_t
  attach_function :IOCreatePlugInInterfaceForService, [:io_service_t, cf_uuid_ref, cf_uuid_ref, :pointer, :pointer], :kern_return_t
  attach_function :IOObjectRelease, [:io_object_t], :kern_return_t
  # rubocop:enable Layout/LineLength, Style/SymbolArray
end
