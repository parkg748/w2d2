require_relative 'board'
require 'singleton'

class Piece
  attr_reader :color, :board, :pos
  
  def initialize(color, pos)
    @color = color
    @board = board
    @pos = pos
  end
  
  def inspect 
    "P"
  end 
  
  
end

module SlidingPiece
  HORIZONTAL_DIRS = [[0, -1],[0, 1],[-1, 0],[1, 0]]
  DIAGONAL_DIRS = [[1, -1],[1, 1],[-1, 1],[-1, -1]]
  
  def horizontal_dirs
    HORIZONTAL_DIRS
  end
  
  def diagonal_dirs
    DIAGONAL_DIRS
  end

  def moves(hash_pos)
    array = []
    hash_pos.each do |k, v|
      v.each do |x|
        if @board[x].class != NullPiece
          break
        end 
        array << x 
      end
    end
    array
  end 
  
end 

module SteppingPiece
  
  def moves(array_pos)
    result = []
    array_pos.each do |pos|
      if @board[x].class == NullPiece 
        result << pos 
      end 
    end
    result 
  end 
  
end 

class King < Piece 
  include SteppingPiece
  
  def move_dirs
    result = []
    result << [self.pos[0] + 1, self.pos[1] + 1]
    result << [self.pos[0] - 1, self.pos[1] - 1]
    result << [self.pos[0] - 1, self.pos[1] + 1]
    result << [self.pos[0] + 1, self.pos[1] - 1]
    result << [self.pos[0], self.pos[1] + 1]
    result << [self.pos[0], self.pos[1] - 1]
    result << [self.pos[0] + 1, self.pos[1]]
    result << [self.pos[0] - 1, self.pos[1]]
    moves(result.uniq)
  end
end 

class Bishop < Piece
  include SlidingPiece
  
  def move_dirs
    result = Hash.new { |h, k| h[k] = [] }
    (1..7).each do |num|
      result[:rightup] << [self.pos[0] + num, self.pos[1] + num] if self.pos[0] + num < 8 && self.pos[1] + num < 8
      result[:leftdown] << [self.pos[0] - num, self.pos[1] - num] if self.pos[0] - num >= 0 && self.pos[1] - num >= 0
      result[:rightdown] << [self.pos[0] - num, self.pos[1] + num] if self.pos[0] - num >= 0 && self.pos[1] + num < 8
      result[:leftup] << [self.pos[0] + num, self.pos[1] - num] if self.pos[0] + num < 8 && self.pos[1] - num >= 0
    end
    moves(result)
  end
end 

class Rook < Piece
  include SlidingPiece
  
  def move_dirs
    result = Hash.new { |h, k| h[k] = [] }
    (self.pos[0] + 1..7).each { |num| result[:up] << [num, self.pos[1]] }
    (self.pos[1] + 1..7).each { |num| result[:right] << [self.pos[0], num] }
    (0...self.pos[0]).each { |num| result[:down] << [num, self.pos[1]] }
    (0...self.pos[1]).each { |num| result[:left] << [self.pos[0], num] }
    result[:down] = result[:down].reverse
    result[:left] = result[:left].reverse
    moves(result)
  end
end 

class Queen < Piece
  include SlidingPiece
  
  def move_dirs
    result = []
    (self.pos[0] + 1..7).each { |num| result[:up] << [num, self.pos[1]] }
    (self.pos[1] + 1..7).each { |num| result[:right] << [self.pos[0], num] }
    (0...self.pos[0]).each { |num| result[:down] << [num, self.pos[1]] }
    (0...self.pos[1]).each { |num| result[:left] << [self.pos[0], num] }
    result[:down] = result[:down].reverse
    result[:left] = result[:left].reverse
    (1..7).each do |num|
      result[:rightup] << [self.pos[0] + num, self.pos[1] + num] if self.pos[0] + num < 8 && self.pos[1] + num < 8
      result[:leftdown] << [self.pos[0] - num, self.pos[1] - num] if self.pos[0] - num >= 0 && self.pos[1] - num >= 0
      result[:rightdown] << [self.pos[0] - num, self.pos[1] + num] if self.pos[0] - num >= 0 && self.pos[1] + num < 8
      result[:leftup] << [self.pos[0] + num, self.pos[1] - num] if self.pos[0] + num < 8 && self.pos[1] - num >= 0
    end
    moves(result)
  end
  
end

class Knight < Piece
  include SteppingPiece
  
  def move_dirs
    result = []
    result << [self.pos[0] - 1, self.pos[1] + 2]
    result << [self.pos[0] + 1, self.pos[1] + 2]
    result << [self.pos[0] - 2, self.pos[1] + 1]
    result << [self.pos[0] - 2, self.pos[1] - 1]
    result << [self.pos[0] + 2, self.pos[1] + 1]
    result << [self.pos[0] + 2, self.pos[1] - 1]
    result << [self.pos[0] - 1, self.pos[1] - 2]
    result << [self.pos[0] + 1, self.pos[1] - 2]
    moves(result.sort.uniq)
  end
end

class Pawn < Piece 
  def move_dirs
    result = []
    result << [self.pos[0] - 1, self.pos[1] + 1]
    result << [self.pos[0] + 1, self.pos[1] + 1]
    result << [self.pos[0] - 1, self.pos[1] - 1]
    result << [self.pos[0] + 1, self.pos[1] - 1]
    moves(result.sort.uniq)
  end
end 



class NullPiece < Piece
  include Singleton
  
  def initialize; end
  
  def inspect
    "N"
  end 
end