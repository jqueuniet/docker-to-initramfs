#!/bin/sh

if [ "$1" != "debian" -a "$1" != "alpine" ] ; then
    dist="debian"
else
    dist=$1
fi

echo Remove previous artifacts
rm -f initramfs.cpio.gz linux

echo Building system image with Docker
docker build -t initramfs-${dist} -f context/Dockerfile.${dist} context
echo Export Docker image to tar
CONTAINER_ID=$(docker run -d initramfs-${dist}:latest /bin/true)
docker export -o initramfs.tar ${CONTAINER_ID}

echo Look for the kernel
KERNEL_PATH=$(tar tvf initramfs.tar --wildcards 'boot/vmlinuz*' | awk '{print $6}' | head -1)
echo Kernel found at ${KERNEL_PATH}, extracting
tar xvf initramfs.tar ${KERNEL_PATH}
mv ${KERNEL_PATH} linux

echo Convert tarball to cpio SVR4
bsdtar --format=newc -cf - @initramfs.tar > initramfs.cpio
echo Compress cpio
gzip -f initramfs.cpio

echo Remove temporary files
rm -f initramfs.tar
