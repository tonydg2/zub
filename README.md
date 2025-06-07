# zub
Avnet ZUBoard-1CG

# encryption / authentication

## auth only ---------------------------------------------------------------
* every partition must be authenticated, can't do individual
```
the_ROM_image:
{
  [pskfile]psk0.pem
  [sskfile]ssk0.pem
  [auth_params]spk_id = 0; ppk_select = 0
  [fsbl_config]bh_auth_enable
  [bootloader, authentication = rsa, destination_cpu = a53-0]/mnt/TDG_512/projects/7_zub/sub/sw/work_sec/platform/export/platform/sw/boot/fsbl.elf
  [destination_cpu = a53-0, authentication = rsa, exception_level = el-3]/mnt/TDG_512/projects/7_zub/sub/sw/work_sec/helloWorld/build/helloWorld.elf
  [destination_device = pl, authentication = rsa]/mnt/TDG_512/projects/7_zub/output_products/bit/top.bit
}
```
### generate keys public/secure
> bootgen -p zu1cg -arch zynqmp -generate_keys auth pem -image key_gen.bif

### generate image
> bootgen -p zu1cg -arch zynqmp -image key_gen.bif -w on -o BOOT.bin

## encrypt ---------------------------------------------------------------
* must encrypt fsbl
* start with fsbl+helloWorld
```
the_ROM_image:
{
  [pskfile]psk0.pem
  [sskfile]ssk0.pem
  [auth_params]spk_id = 0; ppk_select = 0
  [keysrc_encryption]bbram_red_key
  [fsbl_config]bh_auth_enable
  [bootloader, authentication = rsa, encryption = aes, aeskeyfile = fsbl.nky, destination_cpu = a53-0]/mnt/TDG_512/projects/7_zub/sub/sw/work_sec/platform/export/platform/sw/boot/fsbl.elf
  [destination_cpu = a53-0, authentication = rsa, encryption = aes, aeskeyfile = helloWorld.nky, exception_level = el-3]/mnt/TDG_512/projects/7_zub/sub/sw/work_sec/helloWorld/build/helloWorld.elf
  [destination_device = pl, authentication = rsa]/mnt/TDG_512/projects/7_zub/output_products/bit/top.bit
}
```
### generate fsbl/helloWorld keys
> bootgen -p zu1cg -arch zynqmp -image key_gen.bif
### generate image
> bootgen -p zu1cg -arch zynqmp -image key_gen.bif -w on -o BOOT.bin
### program BBRAM
* aes key is in Key 0 of the nky files, Key 0 should match for all
* vitis project, BSP enable xilskey and xilsecure 
* xilskey -> import examples -> xilskey_bbramps_zynqmp_example
* copy Key 0 from nky files to #define XSK_ZYNQMP_BBRAMPS_AES_KEY, run on board jtag or any method, this programs the BBRAM
* copy BOOT.bin to SD and boot, if fail - NO prints on com/uart

### add bitsream enc:
```
the_ROM_image:
{
  [pskfile]psk0.pem
  [sskfile]ssk0.pem
  [auth_params]spk_id = 0; ppk_select = 0
  [keysrc_encryption]bbram_red_key
  [fsbl_config]bh_auth_enable
  [bootloader, authentication = rsa, encryption = aes, aeskeyfile = fsbl.nky, destination_cpu = a53-0]/mnt/TDG_512/projects/7_zub/sub/sw/work_sec/platform/export/platform/sw/boot/fsbl.elf
  [destination_cpu = a53-0, authentication = rsa, encryption = aes, aeskeyfile = helloWorld.nky, exception_level = el-3]/mnt/TDG_512/projects/7_zub/sub/sw/work_sec/helloWorld/build/helloWorld.elf
  [destination_device = pl, authentication = rsa, encryption = aes, aeskeyfile = top.nky]/mnt/TDG_512/projects/7_zub/output_products/bit/top.bit
}
```

## 