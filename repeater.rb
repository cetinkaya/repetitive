# 2015 - Ahmet Cetinkaya

class Job
  attr_reader :timer
  
  def initialize(timer, blk)
    @timer = timer
    @blk = blk
    @time = 0
  end

  def iterate(dt)
    if @time <= 0
      @blk.call
      @time = @timer
    end
    @time -= dt
  end
end

class Array
  def gcd
    mn = min
    mn.step(1, -1) do |g|
      divisible_by_all = true
      each do |number|
        divisible_by_all = false if number % g != 0
      end
      return g if divisible_by_all
    end
    return 1
  end
end

class Repeater
  def initialize
    @jobs = []
  end

  def every(timer, &blk)
    @jobs<< Job.new(timer, blk)
  end

  def run
    dt = @jobs.map{|job| job.timer}.gcd
    while true
      @jobs.each do |job|
        job.iterate(dt)
      end
      sleep(dt)
    end
  end
end

repeater = Repeater.new

repeater.every(10) do # Every 10 seconds, print 10
  puts "10"
end

repeater.every(20) do # Every 20 seconds, print 20
  puts "20"
end

repeater.run
