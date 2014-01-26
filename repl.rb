require_relative 'lib/lurch'

class REPL
  def run
    loop do
      line = gets.chomp

      exit if line == "exit"

      Handler.dispatch line 
    end
  end

  def accept message
    puts message
  end
end

client = REPL.new
client.run
