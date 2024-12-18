module Directions
  ORTOGONAL = [
		[-1, 0], [1, 0], [0, -1], [0, 1]
  ].freeze
  
  DIAGONAL = [
    [1, 1], [1, -1], [-1, -1], [-1, 1]
  ].freeze

  ALL = (Directions::ORTOGONAL + Directions::DIAGONAL).freeze
end