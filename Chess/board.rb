require_relative 'piece'
require 'byebug'

class Board  
  attr_accessor :grid 
    
  def initialize
    @grid = fill_grid
  end
  
  def [](pos)
    row, col = pos
    @grid[row][col]
  end
  
  def []=(pos, val)
    row, col = pos
    @grid[row][col] = val
  end
  
  def fill_grid
    # first_and_end_row = ['Rook', 'Knight', 'Bishop', 'Queen','King', 'Bishop', 'Knight', 'Rook']
    result = []
    4.times do |x|
      array = []
      8.times do |y|
        array << NullPiece.instance
      end
      result << array
    end
    pawn_array = []
    pawn_array1 = []
    (0..7).each { |x| pawn_array << [0,x] }
    (0..7).each { |x| pawn_array1 << [x,7] }
    pawn_array.each_with_index do |x, i|
      pawn_array[i] = Pawn.new(:black,x)
      pawn_array1[i] = Pawn.new(:white,x)
    end
    result.unshift(pawn_array)
    result << pawn_array1
    result.unshift([Rook.new(:black,[0,0]),Knight.new(:black,[0,1]),Bishop.new(:black,[0,2]),Queen.new(:black,[0,3]),King.new(:black,[0,4]),Bishop.new(:black,[0,5]),Knight.new(:black,[0,6]),Rook.new(:black,[0,7])])
    result << [Rook.new(:white,[0,7]),Knight.new(:white,[1,7]),Bishop.new(:white,[2,7]),Queen.new(:white,[3,7]),King.new(:white,[4,7]),Bishop.new(:white,[5,7]),Knight.new(:white,[6,7]),Rook.new(:white,[7,7])]
    result 
  end 
  
  def move_piece(start_pos, end_pos)
    raise ArgumentError if self[start_pos].class == NullPiece || (end_pos.first > 7 || end_pos.last > 7) || start_pos1.all? { |x| x < 0 } 
    self[end_pos], self[start_pos] =  self[start_pos], self[end_pos]
  end
  
  def valid_pos?(position)
    !(self[position].class == NullPiece || self[position].class == Piece)
  end

  
end

if __FILE__ == $PROGRAM_NAME
  check = Board.new
  p check.grid 
  p check.move_piece([0, 0], [3, 3])
  p check.grid 
end 
