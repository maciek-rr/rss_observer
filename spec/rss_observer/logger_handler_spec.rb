# frozen_string_literal: true

require 'rss_observer/logger_handler'
require 'logger'

RSpec.describe RssObserver::LoggerHandler do
  subject(:handler) { described_class.new(logger_mock) }
  let(:logger_mock) { instance_double(Logger) }

  describe '#final_memory' do
    subject { handler.final_memory(100.0) }

    context 'when #inital_memory was called first' do
      before do
        handler.initial_memory(99.0)
      end

      it 'calls the logger' do
        expect(logger_mock).to receive(:info).with('Memory change: 1.0 KB')
        subject
      end
    end

    context 'when #initial_memory was not called first' do
      it { is_expected.to be_nil }
    end
  end
end
