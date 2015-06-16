# encoding: utf-8

require 'spec_helper'

module Punchblock
  class Event
    describe InputTimersStarted do
      it 'registers itself' do
        expect(RayoNode.class_from_registration(:'input-timers-started', 'urn:xmpp:rayo:prompt:1')).to eq(described_class)
      end

      describe "from a stanza" do
        let(:stanza) { "<input-timers-started xmlns='urn:xmpp:rayo:prompt:1' />" }

        subject { RayoNode.from_xml parse_stanza(stanza).root, '9f00061', '1' }

        it { is_expected.to be_instance_of described_class }

        it_should_behave_like 'event'
      end
    end
  end
end
