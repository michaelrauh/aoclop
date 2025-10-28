#lang chimera

countguesser main
  find:
    read: 4 by dash
  end

  assuming:
    and a, b:
      a - b <= 0
    end

    pador a, b, c, d:
      b = c and a != b and c != d
    end
  end
end

main