#child follows child not parent
set follow-fork-mode child
set disassembly-flavor intel
b heap_walk.heap_loop

display/x $rdi
display/x $rdi
display/x $rax
display/x $rsp
display/x $r10
define 1col_lo
    set $pos=0
    while ($pos < $arg0)
        x /xg $arg1-$pos
        set $pos=$pos+8
    end
end

define 1col_hi
    set $pos=0
    while ($pos < $arg0)
        x /xg $arg1+$pos
        set $pos=$pos+8
    end
end
