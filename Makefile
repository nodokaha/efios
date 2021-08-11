all: main.efi
main.efi: main.so
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel -j .rela -j .reloc --target=efi-app-x86_64 main.so main.efi
main.so: main.o
	ld main.o /usr/lib64/crt0-efi-x86_64.o -nostdlib -znocombreloc -T /usr/lib64/elf_x86_64_efi.lds -shared -Bsymbolic -L /usr/lib64 -l:libgnuefi.a -l:libefi.a -o main.so
main.o:
	gcc main.c -c -fno-stack-protector -fpic -fshort-wchar -mno-red-zone -I/usr/include/efi/ -I/usr/include/efi/x86_64/ -DEFI_FUNCTION_WRAPPER -o main.o
# run:
# 	qemu-system-x86_64 		-drive file=/usr/share/edk2-ovmf/OVMF_CODE.fd,if=pflash,format=raw,unit=0,readonly=on main.efi
run:
	uefi-run -b /usr/share/edk2-ovmf/OVMF_CODE.fd main.efi 
clean:
	rm *.o *.so *.efi
deps:
	cargo install uefi-run
