#lang graphical

for wire in read: 3 by newline:
  graph.changecolor()
  for direction, magnitude in wire by comma:
    upmultiplier = match direction in {U: 1, D: -1, other: 0}
    leftmultiplier = match direction in {L: 1, R: -1, other: 0}
    graph.add(upmultiplier * magnitude, rightmultiplier * magnitude)
  end
end

graph.intersects().magnitudes().minimum()