require 'spec_helper'

describe Signal do
  let(:observable) { Observable.new }
  let(:callable) { Callable.new }

  context 'using blocks' do
    it 'triggers event' do
      observable.on(:ready, &callable)
      expect(callable).to receive(:called).with(no_args)

      observable.emit(:ready)
    end

    it 'triggers event with arguments' do
      observable.on(:ready, &callable)
      expect(callable).to receive(:called).with(1, 2, 3)

      observable.emit(:ready, 1, 2, 3)
    end

    it 'triggers before event' do
      observable.before(:ready, &callable)
      expect(callable).to receive(:called).with(no_args)

      observable.emit(:ready)
    end

    it 'triggers before event with arguments' do
      observable.before(:ready, &callable)
      expect(callable).to receive(:called).with(1, 2, 3)

      observable.emit(:ready, 1, 2, 3)
    end

    it 'triggers after event' do
      observable.after(:ready, &callable)
      expect(callable).to receive(:called).with(no_args)

      observable.emit(:ready)
    end

    it 'triggers after event with arguments' do
      observable.after(:ready, &callable)
      expect(callable).to receive(:called).with(1, 2, 3)

      observable.emit(:ready, 1, 2, 3)
    end

    it 'chains events' do
      before_callable = Callable.new
      on_callable = Callable.new
      after_callable = Callable.new

      observable
        .before(:ready, &before_callable)
        .on(:ready, &on_callable)
        .after(:ready, &after_callable)

      expect(before_callable).to receive(:called).with(no_args).ordered
      expect(on_callable).to receive(:called).with(no_args).ordered
      expect(after_callable).to receive(:called).with(no_args).ordered

      observable.emit(:ready)
    end

    it 'keeps context' do
      context = nil
      callable = -> { context = self }
      observable.on(:ready, &callable)
      observable.emit(:ready)

      expect(context).to eql(self)
    end
  end

  context 'using listeners' do
    it 'triggers event for listener' do
      callable.respond_to(:on_ready)
      observable.listeners << callable
      expect(callable).to receive(:called).with(no_args)

      observable.emit(:ready)
    end

    it 'triggers event for listener with arguments' do
      callable.respond_to(:on_ready)
      observable.listeners << callable
      expect(callable).to receive(:called).with(1, 2, 3)

      observable.emit(:ready, 1, 2, 3)
    end
  end
end