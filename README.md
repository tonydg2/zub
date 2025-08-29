# zub
Avnet ZUBoard-1CG

### DFX partial live load
#### Embedding bitstream data in header file
- Generate partials using -RMbin. Only works for -RM partial builds.  
- Run xxd to convert bin to header:  
  > xxd -i rm_partial.bin > rm_partial.h  
- bare-metal SW see:  /sub/sw/src/zub/dfx_bitsream_load/embedded_in_mem/