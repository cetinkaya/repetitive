# 2015 - Ahmet Cetinkaya

class Task
  attr_reader :timer
  
  def initialize(timer, starting_now = true, &blk)
    @timer = timer
    @blk = blk
    if starting_now
      @time = 0
    else
      @time = timer
    end
  end

  def iterate(dt)
    @time -= dt
    if @time <= 0
      @blk.call
      @time = @timer
    end
    @time
  end
end

class Repeater
  def initialize
    @tasks = []
  end

  def every(timer, starting_now = true, &blk)
    @tasks<< Task.new(timer, starting_now, &blk)
  end

  def run
    dt = 0
    while true
      remaining_times = @tasks.map do |task|
        task.iterate(dt)
      end
      dt = remaining_times.min
      sleep(dt)
    end
  end
end

repeater = Repeater.new

repeater.every(10.1) do # Every 10.1 seconds, print 10.1
  puts "10.1"
end

repeater.every(20.1) do # Every 20.1 seconds, print 20.1
  puts "20.1"
end

repeater.run
