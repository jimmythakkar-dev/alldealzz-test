class Time
  def round_off(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds).utc
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds).utc
  end

  def ceiling(seconds = 60)
    Time.at((self.to_f / seconds).ceil * seconds).utc
  end
end

# t = Time.now
# t.round_off(30.minutes)
# t.floor(30.minutes)