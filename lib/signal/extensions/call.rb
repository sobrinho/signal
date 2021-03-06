module Signal
  def self.call
    Extensions::Call
  end

  module Extensions
    module Call
      def self.included(target)
        target.include(Signal)
        target.extend(ClassMethods)
      end

      module ClassMethods
        def call(*args, &block)
          new(*args).tap do |instance|
            yield(instance) if block_given?
            instance.call
          end
        end
      end
    end
  end
end
