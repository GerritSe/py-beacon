require 'json'

module AIK
  class BLEMultiThread
    attr_reader :running

    def initialize(device_count = 1)
      @device_count = device_count
      @running = false
    end

    def start(&block)
      return if @running

      @running = true
      @threads = []
      0.upto(@device_count - 1) do |device_id|
        @threads << Thread.new do
          yield device_id
        end
      end
    end

    def stop
      return unless @running

      @threads.each {|thread| thread.exit}
      @running = false
    end
  end
end
