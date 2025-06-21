# zub
Avnet ZUBoard-1CG  
vivado/vitis 2025.1

## AXI DMA

#### DMA Read
* Read from PS memory, PS 'send' data to PL
* Make sure PS interface is 128-bit (NOT 64), and DMA IP memory map data width = 128, Stream data width = 64
* * When all was 64-bit, DMA transfers were 'skipping' every other 64bit word.


