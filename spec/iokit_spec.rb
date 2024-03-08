# frozen_string_literal: true

RSpec.describe Iokit do
  it "has a version number" do
    expect(Iokit::VERSION).not_to be_nil
  end

  describe "IORegistryGetRootEntry" do
    it "returns a register entry" do
      master_port = described_class.kIOMasterPortDefault

      value = described_class.IORegistryGetRootEntry(master_port)

      expect(value).to be_a(Integer)
    end
  end
end
