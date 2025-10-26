#lang brag
chimera-program : /NEWLINE* mappetizer-block /NEWLINE* ID
mappetizer-block : /MAPPETIZER ID /NEWLINE* read scope-block /PIPE collect /NEWLINE /END
read           : /READ INTEGER delimiter
scope-block    : /PIPE /DOWNSCOPE /PIPE all-ops /PIPE /UPSCOPE | /PIPE /DOWNSCOPE /PIPE converge-block /PIPE /UPSCOPE
delimiter      : DELIMITER
all-ops        : op*
converge-block : /GT all-ops /LT
op             : OP | OP INTEGER | OP /PIPE | OP INTEGER /PIPE
collect        : COLLECT