#lang countguesser

find:
  min, max in read 4 by dash
end

assuming:
  for a, b:
    a - b >= 0
  end

  or:
    for a, b:
      a = b
    end
  end
end