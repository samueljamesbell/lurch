class Lurch

  attr_accessor :queue

  def initialize
    @queue = []
    @connections = []
  end

  def start
    @server = EventMachine.start_server '0.0.0.0', 2013, Connection do |conn|
      @connections << conn
    end
  end

  def accept(event)
    @queue << event
    puts @queue.inspect
  end

  def send(data)
    @connections.each { |conn| conn.send_data(data) }
  end

end

