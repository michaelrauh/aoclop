#lang countguesser

find:
  min, max in read 4 by dash
end

assuming:
  and a, b:
    a - b >= 0
  end

  or a, b:
    a = b
  end
end
  