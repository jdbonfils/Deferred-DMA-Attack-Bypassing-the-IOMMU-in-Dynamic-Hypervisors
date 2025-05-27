cmd_/home/jean/Desktop/jh_workdir/jailhouse/configs/../../configs/root.o := /media/jean/work/arm-gnu-toolchain/bin/aarch64-none-linux-gnu-gcc -Wp,-MMD,/home/jean/Desktop/jh_workdir/jailhouse/configs/../../configs/.root.o.d  -nostdinc -isystem /media/jean/work/arm-gnu-toolchain/bin/../lib/gcc/aarch64-none-linux-gnu/13.3.1/include -I/home/jean/Desktop/jh_workdir/jailhouse/configs/../hypervisor/arch/arm64/include -I/home/jean/Desktop/jh_workdir/jailhouse/configs/../hypervisor/include -I/home/jean/Desktop/jh_workdir/jailhouse/configs/../include -include ./include/linux/compiler_types.h -D__KERNEL__ -mlittle-endian -DKASAN_SHADOW_SCALE_SHIFT= -fmacro-prefix-map=./= -Werror -Wall -Wextra -D__LINUX_COMPILER_TYPES_H -include /home/jean/Desktop/jh_workdir/jailhouse/configs/../include/jailhouse/config.h    -DKBUILD_MODFILE='"/home/jean/Desktop/jh_workdir/jailhouse/configs/root"' -DKBUILD_BASENAME='"root"' -DKBUILD_MODNAME='"root"' -D__KBUILD_MODNAME=kmod_root -c -o /home/jean/Desktop/jh_workdir/jailhouse/configs/../../configs/root.o /home/jean/Desktop/jh_workdir/jailhouse/configs/../../configs/root.c

source_/home/jean/Desktop/jh_workdir/jailhouse/configs/../../configs/root.o := /home/jean/Desktop/jh_workdir/jailhouse/configs/../../configs/root.c

deps_/home/jean/Desktop/jh_workdir/jailhouse/configs/../../configs/root.o := \
  include/linux/compiler_types.h \
    $(wildcard include/config/HAVE_ARCH_COMPILER_H) \
    $(wildcard include/config/CC_HAS_ASM_INLINE) \
  /home/jean/Desktop/jh_workdir/jailhouse/configs/../include/jailhouse/config.h \
    $(wildcard include/config/MACH_ZYNQMP_ZCU104) \
    $(wildcard include/config/NO_SUPERPAGES) \
    $(wildcard include/config/IRQ_PASSTHRU) \
  /home/jean/Desktop/jh_workdir/jailhouse/configs/../hypervisor/include/jailhouse/types.h \
  /home/jean/Desktop/jh_workdir/jailhouse/configs/../hypervisor/arch/arm64/include/asm/types.h \
  /home/jean/Desktop/jh_workdir/jailhouse/configs/../include/jailhouse/cell-config.h \
  /home/jean/Desktop/jh_workdir/jailhouse/configs/../include/jailhouse/console.h \
  /home/jean/Desktop/jh_workdir/jailhouse/configs/../include/jailhouse/pci_defs.h \

/home/jean/Desktop/jh_workdir/jailhouse/configs/../../configs/root.o: $(deps_/home/jean/Desktop/jh_workdir/jailhouse/configs/../../configs/root.o)

$(deps_/home/jean/Desktop/jh_workdir/jailhouse/configs/../../configs/root.o):
