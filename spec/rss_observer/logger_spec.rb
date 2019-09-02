# frozen_string_literal: true

require 'rss_observer/logger'
require 'logger'

RSpec.describe RssObserver::Logger do
  subject { described_class.new(logger_mock) }
  let(:logger_mock) { instance_double(Logger) }

  describe '#call' do
    it 'passes message to logger' do
      expect(logger_mock).to receive(:info).with('Memory change: 10.0 KB')
      subject.call(10.0)
    end
  end
end
