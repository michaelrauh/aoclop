#lang chimera

graphical main
  for wire in read: 3 by newline:
    graph.changecolor()
    for direction, magnitude in wire by comma:
      rightmultiplier = match direction in {'L': -1, 'R': 1} or 0
      upmultiplier = match direction in {'U': 1, 'D': -1} or 0
      graph.add(rightmultiplier * magnitude, upmultiplier * magnitude)
    end
  end
  graph.intersects().magnitudes().minimum()
end

main
