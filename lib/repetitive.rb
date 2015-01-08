# 2015 - Ahmet Cetinkaya

module Repetitive

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
  
  # Add a task to be run every timer seconds, If starting_now is true,
  # task is started immediately.  The task is to be provided as a
  # block. The current implementation assumes that the running times
  # of tasks are negligible.
  #
  # Example:
  #   require "repetitive"
  #   repeater = Repetitive::Repeater.new
  #   repeater.every(10) do
  #     puts "10 seconds"
  #   end
  #   repeater.run
  def every(timer, starting_now = true, &blk)
    @tasks<< Task.new(timer, starting_now, &blk)
  end

  # Start repeater. The tasks (defined with method every) are
  # repetitively executed.
  #
  # Example:
  #   require "repetitive"
  #   repeater = Repetitive::Repeater.new
  #   repeater.every(10) do # every 10 seconds print 10
  #     puts "10 seconds"
  #   end
  #   repeater.every(20) do # every 20 seconds print 20
  #     puts "20 seconds"
  #   end
  #   repeater.run
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

class ThreadedRepeater < Repeater
  # Start repeater. The tasks (defined with method every) are
  # repetitively executed in different threads.
  def run
    threads = @tasks.map do |task|
      Thread.new do
        dt = 0
        while true
          dt = task.iterate(dt)
          sleep(dt)
        end
      end
    end

    threads.each do |thread|
      thread.join
    end
  end
end

end
