class Rotater
  # Given a list of items and a retention policy, determines
  # which items should be kept and which should be deleted to
  # match the policy.
  #
  # The time_periods policy should be a hash that looks something
  # like this:
  #
  # {
  #   :hourly  => { :seconds => 60 * 60, :format => '%Y-%m-%d-%H', :keep => 0 },
  #   :daily   => { :seconds => 24 * 60 * 60, :format => '%Y-%m-%d', :keep => 0 },
  #   :weekly  => { :seconds => 7 * 24 * 60 * 60, :format => '%Y-%W', :keep => 0 },
  #   :monthly => { :seconds => 30 * 24 * 60 * 60, :format => '%Y-%m', :keep => 0 },
  #   :yearly  => { :seconds => 12 * 30 * 24 * 60 * 60, :format => '%Y', :keep => 0 },
  # }
  #
  # The items array should contain hashes with a key :created_at that
  # will be used for evaluating the item against the policy. The entire
  # hash will be passed back in the yield, so other identifying data
  # can be included. For example:
  #
  # [ { :created_at => Time.parse("2010-10-01"), :object_id => "a-12345" },
  #   { :created_at => Time.parse("2010-10-02"), :object_id => "b-43212" } ]
  #
  # @param [Array] items A list of items to be considered for
  #   deletion according to the policy.
  #
  # @param [Hash] time_periods A hash describing the rotation policy.
  #
  # @param [Boolean] keep_last Whether or not to always keep the most
  #   recent item, ignoring the time-based policy.
  #
  # @yield [Hash,Boolean,String] Yields each item in the array of items.
  #   The second parameter will be true if the item should be deleted,
  #   The third parameter will be the reason the item was kept, if kept.
  def self.rotate_items(items, time_periods, keep_last)
    items.each do |item|
      keep_reason = nil

      periods.keys.sort { |a, b| periods[a][:seconds] <=> periods[b][:seconds] }.each do |period|
        period_info = periods[period]
        keep = period_info[:keep]
        keeping = (period_info[:keeping] ||= {})

        time_string = item[:created_at].strftime period_info[:format]
        if Time.now - item[:created_at] < keep * period_info[:seconds]
          if !keeping.key?(time_string) && keeping.length < keep
            keep_reason = period
            keeping[time_string] = item[:created_at]
          end
          break
        end
      end

      if keep_reason.nil? && item == items.last && keep_last
        keep_reason = 'last'
      end

      yield item, keep_reason.nil?, keep_reason
    end
  end
end