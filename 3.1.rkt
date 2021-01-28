#lang graphical

for wire in read 3 by newline:
  graph.change_color()
  for direction, magnitude in wire by comma:
    up-multiplier  = direction in {U: 1, D: -1, other: 0}
    left-multiplier = direction in {L: 1, R: -1, other: 0}
    graph.add(up-multiplier * magnitude, right-multiplier * magnitude)
  end
end

graph.intersects().magnitudes().minimum()