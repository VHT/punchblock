# encoding: utf-8

require 'spec_helper'

module Punchblock
  module Command
    describe Answer do
      it 'registers itself' do
        expect(RayoNode.class_from_registration(:answer, 'urn:xmpp:rayo:1')).to eq(described_class)
      end

      describe "from a stanza" do
        let(:stanza) do
          <<-STANZA
            <answer xmlns="urn:xmpp:rayo:1">
              <header name="X-skill" value="agent" />
              <header name="X-customer-id" value="8877" />
            </answer>
          STANZA
        end

        subject { RayoNode.from_xml parse_stanza(stanza).root, '9f00061', '1' }

        it { should be_instance_of described_class }

        describe '#headers' do
          subject { super().headers }
          it { should == { 'X-skill' => 'agent', 'X-customer-id' => '8877' } }
        end

        context "with no headers provided" do
          let(:stanza) { '<answer xmlns="urn:xmpp:rayo:1"/>' }

          describe '#headers' do
            subject { super().headers }
            it { should == {} }
          end
        end
      end

      describe "when setting options in initializer" do
        subject { described_class.new headers: { 'X-skill' => 'agent', 'X-customer-id' => '8877' } }

        describe '#headers' do
          subject { super().headers }
          it { should == { 'X-skill' => 'agent', 'X-customer-id' => '8877' } }
        end

        describe "exporting to Rayo" do
          it "should export to XML that can be understood by its parser" do
            new_instance = RayoNode.from_xml subject.to_rayo
            expect(new_instance).to be_instance_of described_class
            expect(new_instance.headers).to eq({ 'X-skill' => 'agent', 'X-customer-id' => '8877' })
          end

          it "should render to a parent node if supplied" do
            doc = Nokogiri::XML::Document.new
            parent = Nokogiri::XML::Node.new 'foo', doc
            doc.root = parent
            rayo_doc = subject.to_rayo(parent)
            expect(rayo_doc).to eq(parent)
          end

          context "with multiple headers of the same name" do
            subject { described_class.new headers: { 'X-skill' => ['sales', 'complaints'] } }

            it "should export to XML that can be understood by its parser" do
              new_instance = RayoNode.from_xml subject.to_rayo
              expect(new_instance).to be_instance_of described_class
              expect(new_instance.headers).to eq({ 'X-skill' => ['sales', 'complaints'] })
            end
          end
        end
      end
    end
  end
end
