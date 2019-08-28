#child follows child not parent
set follow-fork-mode child
set disassembly-flavor intel
b _start
#b _start.parentCode
b _start.childAcode
display/s $rdi
display/d $rax
display/s $rsp
display/s $r9
define 1col_lo
    set $pos=0
    while ($pos < $arg0)
        x /xg $rsp-$pos
        set $pos=$pos+8
    end
end

define 1col_hi
    set $pos=0
    while ($pos < $arg0)
        x /sb $rsp+$pos
        set $pos=$pos+8
    end
end
