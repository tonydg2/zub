# zub
Avnet ZUBoard-1CG

#### notes
/mnt/TDG_512/projects/7_zub/sub/sw/work_sec/platform/export/platform/sw/boot/fsbl.elf
/mnt/TDG_512/projects/7_zub/sub/sw/work_sec/helloWorld/build/helloWorld.elf
/mnt/TDG_512/projects/7_zub/output_products/bit/top.bit

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

# encryption / authentication
* skip to PUF section at end to do everything. no BBRAM required
## auth only ---------------------------------------------------------------
* every partition must be authenticated, can't do individual
```
the_ROM_image:
{
  [pskfile] psk0.pem
  [sskfile] ssk0.pem
  [auth_params] spk_id = 0; ppk_select = 0
  [fsbl_config] bh_auth_enable
  [bootloader, authentication = rsa, destination_cpu = a53-0] fsbl.elf
  [destination_cpu = a53-0, authentication = rsa, exception_level = el-3] helloWorld.elf
  [destination_device = pl, authentication = rsa] top.bit
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
  [pskfile] psk0.pem
  [sskfile] ssk0.pem
  [auth_params] spk_id = 0; ppk_select = 0
  [keysrc_encryption] bbram_red_key
  [fsbl_config] bh_auth_enable
  [bootloader, authentication = rsa, encryption = aes, aeskeyfile = fsbl.nky, destination_cpu = a53-0] fsbl.elf
  [destination_cpu = a53-0, authentication = rsa, encryption = aes, aeskeyfile = helloWorld.nky, exception_level = el-3] helloWorld.elf
  [destination_device = pl, authentication = rsa] top.bit
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
* copy BOOT.bin to SD and boot, if boot fails - NO prints on com/uart

### add bitsream enc:
```
the_ROM_image:
{
  [pskfile] psk0.pem
  [sskfile] ssk0.pem
  [auth_params] spk_id = 0; ppk_select = 0
  [keysrc_encryption] bbram_red_key
  [fsbl_config] bh_auth_enable
  [bootloader, authentication = rsa, encryption = aes, aeskeyfile = fsbl.nky, destination_cpu = a53-0] fsbl.elf
  [destination_cpu = a53-0, authentication = rsa, encryption = aes, aeskeyfile = helloWorld.nky, exception_level = el-3] helloWorld.elf
  [destination_device = pl, authentication = rsa, encryption = aes, aeskeyfile = top.nky] top.bit
}
```

## Operational Key
add opt_key 

```
the_ROM_image:
{
  [pskfile] psk0.pem
  [sskfile] ssk0.pem
  [auth_params] spk_id = 0; ppk_select = 0
  [keysrc_encryption] bbram_red_key
  [fsbl_config] bh_auth_enable, opt_key
  [bootloader, authentication = rsa, encryption = aes, aeskeyfile = fsbl.nky, destination_cpu = a53-0] fsbl.elf
  [destination_cpu = a53-0, authentication = rsa, encryption = aes, aeskeyfile = helloWorld.nky, exception_level = el-3] helloWorld.elf
  [destination_device = pl, authentication = rsa, encryption = aes, aeskeyfile = top.nky] top.bit
}
```
### generate image
* delete old nky files
* re-generate nky files (adds 'Key Opt' value):
> bootgen -p zu1cg -arch zynqmp -image key_gen.bif
* re-program BBRAM with new Key 0 as above
* generate image:
> bootgen -p zu1cg -arch zynqmp -image key_gen.bif -w on -o BOOT.bin

## Key Rolling
add 'blocks = 1728(*)' to each encrypted partition

```
the_ROM_image:
{
  [pskfile] psk0.pem
  [sskfile] ssk0.pem
  [auth_params] spk_id = 0; ppk_select = 0
  [keysrc_encryption] bbram_red_key
  [fsbl_config] bh_auth_enable, opt_key
  [bootloader, authentication = rsa, encryption = aes, aeskeyfile = fsbl.nky, blocks = 1728(*), destination_cpu = a53-0] fsbl.elf
  [destination_cpu = a53-0, authentication = rsa, encryption = aes, aeskeyfile = helloWorld.nky, blocks = 1728(*), exception_level = el-3] helloWorld.elf
  [destination_device = pl, authentication = rsa, encryption = aes, aeskeyfile = top.nky, blocks = 1728(*)] top.bit
}
```
### generate image
* delete old nky files
* re-generate nky files (adds 'Key Opt' value):
> bootgen -p zu1cg -arch zynqmp -image key_gen.bif
* re-program BBRAM with new Key 0 as above
* generate image:
> bootgen -p zu1cg -arch zynqmp -image key_gen.bif -w on -o BOOT.bin

## PUF
* see UG1209 'PUF Registration in Boot Header Mode'
* vitis project, BSP enable xilskey and xilsecure 
* xilskey -> import examples -> xilskey_puf_registration_example
* set #define XSK_PUF_INFO_ON_UART TRUE
* verify #define XSK_PUF_PROGRAM_EFUSE is set to FALSE.
* set Set XSK_PUF_AES_KEY to Key 0 of the nky files
* set XSK_PUF_BLACK_KEY_IV to users choice
* build and run the app on the board
* Save the PUF Syndrome data that starts after 'App PUF Syndrome data Start!!!' and ends at 'PUF Syndrome data End!!!', non-inclusive, to a file named helperdata.txt.
* Save the black key IV identified by 'App: Black Key IV' to a file named black_iv.txt
* Save the black key to a file named black_key.txt.

```
the_ROM_image:
{
  [pskfile] psk0.pem
  [sskfile] ssk0.pem
  [auth_params] spk_id = 0; ppk_select = 0
  [keysrc_encryption] bh_blk_key
  [bh_key_iv] black_iv.txt
  [bh_keyfile] black_key.txt
  [puf_file] helperdata.txt
  [fsbl_config] bh_auth_enable, opt_key, puf4kmode, shutter=0x0100005E, pufhd_bh
  [bootloader, authentication = rsa, encryption = aes, aeskeyfile = fsbl.nky, blocks = 1728(*), destination_cpu = a53-0] fsbl.elf
  [destination_cpu = a53-0, authentication = rsa, encryption = aes, aeskeyfile = helloWorld.nky, blocks = 1728(*), exception_level = el-3] helloWorld.elf
  [destination_device = pl, authentication = rsa, encryption = aes, aeskeyfile = top.nky, blocks = 1728(*)] top.bit
}
```
### generate image
> bootgen -p zu1cg -arch zynqmp -image key_gen.bif -w on -o BOOT.bin
* works. re-do from scratch with new keys to verify
