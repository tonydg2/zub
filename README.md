# zub
Avnet ZUBoard-1CG

## DFX partial live load
### Embedding bitstream data in header file
- Generate partials using -RMbin. Only works for -RM partial builds.  
- Run xxd to convert bin to header:  
  > xxd -i rm_partial.bin > rm_partial.h  
- bare-metal SW see:  /sub/sw/src/zub/dfx_bitsream_load/embedded_in_mem/



# -------------------------------------------------------------------------------------------------
## Instructions to repeat QSPI flash partial bitsream load
### build fpga project
>tclsh BUILD.tcl -name PRJ0

### build two partials - this is only needed to get bin files (bin generation only implemented for partial builds currently - to be updated)
>tclsh BUILD.tcl -RM RM0/RM_led_2.sv -skipIP -skipBD -RMbin
>tclsh BUILD.tcl -RM RM1/RM_led2_2.sv -skipIP -skipBD -RMbin

### generate headers. don't need here, just to verify file size. these can also be used to verify data, SW will read out some of the data read from the flash
>xxd -i RM0_RM_led_2_partial.bin > RM0_RM_led_2_partial.h
*  135248 bytes
>xxd -i RM1_RM_led2_2_partial.bin > RM1_RM_led2_2_partial.h
*  287912 bytes

### create platform proj in vitis
  - enable xilfpga in BSP
### build platform (need fsbl) 

### load bin files onto QSPI flash
* RM0 to addr offset 0x00010000:
> program_flash -f /mnt/TDG_512/projects/1_zub_test/output_products/bit/RM0/RM0_RM_led_2_partial.bin -offset 0x00010000 -flash_type qspi-x4-single -fsbl /mnt/TDG_512/projects/1_zub_test/sub/sw/work/platform/zynqmp_fsbl/build/fsbl.elf -blank_check -verify -url TCP:127.0.0.1:3121
* RM1 to addr offset 0x00040000:
> program_flash -f /mnt/TDG_512/projects/1_zub_test/output_products/bit/RM1/RM1_RM_led2_2_partial.bin -offset 0x00040000 -flash_type qspi-x4-single -fsbl /mnt/TDG_512/projects/1_zub_test/sub/sw/work/platform/zynqmp_fsbl/build/fsbl.elf -blank_check -verify -url TCP:127.0.0.1:3121

### create app in vitis (/sub/sw/src/zub/dfx_bitsream_load/qspi_flash_cleaner/)
  run 'i'   -   run_qspi_read_test(); // reads both bin files from flash into memory
  run 'j'   -   loadPartialBit((UINTPTR)ReadBuffer, rm0_len);
  run 'k'   -   loadPartialBit((UINTPTR)ReadBuffer2, rm1_len);

# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
### partial bitstream (bin) in QSPI flash (NOT a boot image)
#### NOTES
 * byte sizes below derived from above xxd command, used the same bitstreams. necessary in SW for load from QSPI and bitsream load

 - commands/output from program flash with boot image - vitis gui:

program_flash -f /mnt/TDG_512/projects/0_zub_dfx_live_load/output_products/test/BOOT.bin -offset 0x00010000 -flash_type qspi-x4-single -fsbl /mnt/TDG_512/projects/0_zub_dfx_live_load/sub/sw/work/platform/zynqmp_fsbl/build/fsbl.elf -blank_check -verify -url TCP:127.0.0.1:3121

program_flash -f /mnt/TDG_512/projects/0_zub_dfx_live_load/output_products/test/BOOT.bin 
  -offset 0x00010000 
  -flash_type qspi-x4-single 
  -fsbl /mnt/TDG_512/projects/0_zub_dfx_live_load/sub/sw/work/platform/zynqmp_fsbl/build/fsbl.elf 
  -blank_check -verify 
  -url TCP:127.0.0.1:3121


##### bitsream A  - RM0_RM_led_2_partial.bin
  - store at addr 0x00010000
  - 135248 bytes, 529 pages
  - Sector size: 4 KB ⇒ sectors to erase = ceil(135,248 / 4,096) = 34.
  - Space that covers: 34 × 4,096 = 139,264 bytes = 0x22000.
  - Address range used: [0x010000, 0x032000).

> program_flash -f /mnt/TDG_512/projects/0_zub_dfx_live_load/output_products/bit/RM0/RM0_RM_led_2_partial.bin -offset 0x00010000 -flash_type qspi-x4-single -fsbl /mnt/TDG_512/projects/0_zub_dfx_live_load/sub/sw/work/platform/zynqmp_fsbl/build/fsbl.elf -blank_check -verify -url TCP:127.0.0.1:3121

##### bitsream B  - RM1_RM_led2_2_partial.bin
  - store at addr 0x00040000
  - 287912 bytes, 1125 pages
  - Sector size (4 KB): sectors to erase = 71
  - Covers 71 × 4096 = 290,816 B = 0x47_000
  - Address range used: [0x0004_0000, 0x0008_7000)

> program_flash -f /mnt/TDG_512/projects/0_zub_dfx_live_load/output_products/bit/RM1/RM1_RM_led2_2_partial.bin -offset 0x00040000 -flash_type qspi-x4-single -fsbl /mnt/TDG_512/projects/0_zub_dfx_live_load/sub/sw/work/platform/zynqmp_fsbl/build/fsbl.elf -blank_check -verify -url TCP:127.0.0.1:3121


Using default mini u-boot image file - /opt/xilinx/2025.1/Vitis/data/xicom/cfgmem/uboot/zynqmp_qspi_x4_single.bin

SF: Detected is25wp256 with page size 256 Bytes, erase size 64 KiB, total 32 MiB
ZynqMP> Sector size = 65536.
WARNING: [Xicom 50-353] WARNING: Flash Mismatched. If flash programming fails, select the correct Flash and try again.
Selected Flash: qspi-x4-single
Detected Flash: is25wp256




---------------------------------------------------------------------------------------------------
Flash layout (example for your 32 MB device)
You’re not booting from QSPI, so the whole chip is yours. One simple, robust map:
0x00000000 — Index header (1 × 4 KB sector)
0x00010000 — Bitstream A (start on a 64 KB boundary)
0x01000000 — Bitstream B (16 MB boundary, easy to remember)
(Replace addresses to taste; just keep them at least 64 KB aligned. 4 KB also works, but 64 KB makes erases fast and tidy.)
Note: Offsets ≥ 16 MB require 4-byte addressing. ZynqMP’s QSPI driver handles this when configured; just be mindful if you write your own low-level ops.



