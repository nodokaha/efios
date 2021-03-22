all: main.efi
main.efi: main.so
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel -j .rela -j .reloc --target=efi-app-x86_64 main.so main.efi
main.so: main.o
	ld main.o /usr/lib/crt0-efi-x86_64.o -nostdlib -znocombreloc -T /usr/lib/elf_x86_64_efi.lds -shared -Bsymbolic -L /usr/lib -l:libgnuefi.a -l:libelf.a -o main.so
main.o:
	gcc main.c -c -fno-stack-protector -fpic -fshort-wchar -mno-red-zone -I/usr/include/efi/ -I/usr/include/efi/x86_64/ -DEFI_FUNCTION_WRAPPER -o main.o
clean:
	rm *.o *.so *.efi
