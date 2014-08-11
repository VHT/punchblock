# encoding: utf-8

require 'spec_helper'

module Punchblock
  describe ProtocolError do
    let(:name)          { :item_not_found }
    let(:text)          { 'Could not find call [id=f6d437f4-1e18-457b-99f8-b5d853f50347]' }
    let(:call_id)       { 'f6d437f4-1e18-457b-99f8-b5d853f50347' }
    let(:component_id)  { 'abc123' }
    subject { ProtocolError.new.setup name, text, call_id, component_id }

    describe '#inspect' do
      subject { super().inspect }
      it { should be == '#<Punchblock::ProtocolError: name=:item_not_found text="Could not find call [id=f6d437f4-1e18-457b-99f8-b5d853f50347]" call_id="f6d437f4-1e18-457b-99f8-b5d853f50347" component_id="abc123">' }
    end

    describe ".exception" do
      context "with no arguments" do
        it "returns the original object" do
          expect(ProtocolError.exception).to eq(ProtocolError.new)
        end
      end

      context "with self as the argument" do
        it "returns the original object" do
          expect(ProtocolError.exception(subject)).to eq(ProtocolError.new(subject.to_s))
        end
      end

      context "with other values" do
        it "returns a new object with the appropriate values" do
          e = ProtocolError.exception 'FooBar'
          expect(e.name).to eq(nil)
          expect(e.text).to eq(nil)
          expect(e.call_id).to eq(nil)
          expect(e.component_id).to eq(nil)
        end
      end
    end

    describe "#exception" do
      context "with no arguments" do
        it "returns the original object" do
          expect(subject.exception).to be subject
        end
      end

      context "with self as the argument" do
        it "returns the original object" do
          expect(subject.exception(subject)).to be subject
        end
      end

      context "with other values" do
        it "returns a new object with the appropriate values" do
          e = subject.exception("Boo")
          expect(e.name).to eq(name)
          expect(e.text).to eq(text)
          expect(e.call_id).to eq(call_id)
          expect(e.component_id).to eq(component_id)
        end
      end
    end

    describe "comparison" do
      context "with the same name, text, call ID and component ID" do
        let(:comparison) { ProtocolError.new.setup name, text, call_id, component_id }
        it { should be == comparison }
      end

      context "with a different name" do
        let(:comparison) { ProtocolError.new.setup :foo, text, call_id, component_id }
        it { should_not be == comparison }
      end

      context "with a different text" do
        let(:comparison) { ProtocolError.new.setup name, 'foo', call_id, component_id }
        it { should_not be == comparison }
      end

      context "with a different call ID" do
        let(:comparison) { ProtocolError.new.setup name, text, 'foo', component_id }
        it { should_not be == comparison }
      end

      context "with a different component ID" do
        let(:comparison) { ProtocolError.new.setup name, text, call_id, 'foo' }
        it { should_not be == comparison }
      end
    end
  end
end
