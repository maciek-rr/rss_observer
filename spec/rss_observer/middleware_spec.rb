# frozen_string_literal: true

RSpec.describe RssObserver::Middleware do
  subject(:middleware) { described_class.new(app, handler) }

  let(:handler) { instance_double(Proc) }
  let(:app) { instance_double(Proc) }

  describe '#call' do
    subject { middleware.call(env) }

    let(:env) { [] }
    let(:get_process_mem) { instance_double(GetProcessMem) }

    before do
      allow(GetProcessMem).to receive(:new).and_return(get_process_mem)
    end

    it 'runs the app and calls handler with calculated mem' do
      expect(get_process_mem).to receive(:kb) { 1000.0 }
      expect(get_process_mem).to receive(:kb) { 2000.0 }
      expect(handler).to receive(:call).with(1000.0)
      expect(app).to receive(:call).with([]).and_return(%w[foo bar baz])

      expect(subject).to match_array(%w[foo bar baz])
    end
  end
end
