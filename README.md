# zub
Avnet ZUBoard-1CG

# encryption / authentication

## auth only
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
>bootgen -p zu1cg -arch zynqmp -image key_gen.bif -w on -o BOOT.bin


