require_relative 'board'
require 'colorize'
require 'colorized_string'
require_relative 'cursor'
require 'byebug'

class Display 
  attr_reader :board, :cursor
  
  def self.render(cursor, board)
    system("clear")
    (board.grid).each_with_index do |row, pos1|
      pipe = ''
      row.each_with_index do |i, pos2|
        if cursor.cursor_pos == [pos1, pos2]
          pipe += ' P'.colorize(:color => :light_blue, :background => :red)
        elsif i.class == Pawn
          i.color == :black ? pipe += ' ♟' : pipe += ' ♙'
        elsif i.class == Rook
          i.color == :black ? pipe += ' ♜' : pipe += ' ♖'
        elsif i.class == Knight
          i.color == :black ? pipe += ' ♞' : pipe += ' ♘'
        elsif i.class == Bishop
          i.color == :black ? pipe += ' ♝' : pipe += ' ♗'
        elsif i.class == Queen
          i.color == :black ? pipe += ' ♛' : pipe += ' ♕'
        elsif i.class == King
          i.color == :black ? pipe += ' ♚' : pipe += ' ♔'
        elsif i.class == NullPiece
          pipe += "  "
        end  
      end 
      pipe += " "
      puts pipe
    end
  end 
  
  def initialize(board = Board.new)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end 
  
  def handle_key(key)
    case key
    when key == :return || key == :space 
      return @cursor.cursor_pos
    when key == :left || key == :right || key == :up || key == :down 
      # Ask about this 
      return @cursor.call_update_pos(key)
    when key == :ctrl_c 
      Process.exit(0)
    end
  end 
  
  
end 

if __FILE__ == $PROGRAM_NAME
  check = Display.new
  while true
    Display.render(check.cursor, check.board)
    check.cursor.get_input
  end
end 
