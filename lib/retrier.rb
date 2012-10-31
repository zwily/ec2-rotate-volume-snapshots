class Retrier
  class Backoff
    def initialize(limit = nil, &block)
      @limit = limit
      @backoff_count = 0
      @exception_checker = block
    end

    def execute(&block)
      begin
        result = yield

        # reset the backoff counter after a successful execution
        @backoff_count = 0

        return result
      rescue Exception => e
        if @exception_checker.call(e)
          @backoff_count += 1

          if @limit && @backoff_count > @limit
            puts "Too many backoff attempts. Sorry it didn't work out."
            raise "Execution still failed after #{@backoff_count} attempts; giving up"
          end

          sleep_time = rand(60) * @backoff_count
          puts "Backing off for #{sleep_time} seconds..."
          sleep sleep_time

          retry
        end
        raise e
      end
    end
  end
end