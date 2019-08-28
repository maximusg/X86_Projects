bits 64
; use printf to push values
section .rodata

allocated: db `%p: Allocated (%lld bytes)\n`,0
unallocated: db `%p: Unallocated (%lld bytes). next: %p, prev: %p\n`,0
tail: db `%p: Tail (%lld bytes)\n`,0

total_alloc: db `A total of %lld bytes are allocated\n`,0
total_free: db `A total of %lld bytes are free\n`,0
test_string: db `print me!`,0
