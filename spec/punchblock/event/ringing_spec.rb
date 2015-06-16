# encoding: utf-8

require 'spec_helper'

module Punchblock
  class Event
    describe Ringing do
      it 'registers itself' do
        expect(RayoNode.class_from_registration(:ringing, 'urn:xmpp:rayo:1')).to eq(described_class)
      end

      describe "from a stanza" do
        let :stanza do
          <<-MESSAGE
<ringing xmlns='urn:xmpp:rayo:1'>
  <!-- Signaling (e.g. SIP) Headers -->
  <header name="X-skill" value="agent" />
  <header name="X-customer-id" value="8877" />
</ringing>
          MESSAGE
        end

        subject { RayoNode.from_xml parse_stanza(stanza).root, '9f00061', '1' }

        it { is_expected.to be_instance_of described_class }

        it_should_behave_like 'event'

        describe '#headers' do
          subject { super().headers }
          it { is_expected.to eq({ 'X-skill' => 'agent', 'X-customer-id' => '8877' }) }
        end

        context "with no headers provided" do
          let(:stanza) { '<ringing xmlns="urn:xmpp:rayo:1"/>' }

          describe '#headers' do
            subject { super().headers }
            it { is_expected.to eq({}) }
          end
        end
      end

      describe "when setting options in initializer" do
        subject { described_class.new headers: { 'X-skill' => 'agent', 'X-customer-id' => '8877' } }

        describe '#headers' do
          subject { super().headers }
          it { is_expected.to eq({ 'X-skill' => 'agent', 'X-customer-id' => '8877' }) }
        end
      end
    end
  end
end
