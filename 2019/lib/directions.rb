module Directions
  ORTOGONAL = [
		[-1, 0], [1, 0], [0, -1], [0, 1]
  ].freeze

  SIGNS = {
    [-1, 0] => '^',
    [1, 0] =>'v', 
    [0, -1] => '<',
    [0, 1] => '>',
  }
  
  DIAGONAL = [
    [1, 1], [1, -1], [-1, -1], [-1, 1]
  ].freeze

  ALL = (Directions::ORTOGONAL + Directions::DIAGONAL).freeze
end