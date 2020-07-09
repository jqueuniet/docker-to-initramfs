Small proof of concept to convert docker images to an initramfs archive usable for PXE and direct QEMU boot. The distribution kernel is also extracted on the side. Debian and Alpine are supported as targets. You will need docker (duh) and bsdtar installed.

The images are kept as is, but there's a lot of room for improvements on size. Kernels and initramfs inside the image can be deleted safely once the former is extracted, you could choose a kernel image more suited to your needs, or you could build your own with everything builtin and not bother installing one at all.
