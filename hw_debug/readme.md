# Trace32 Scripts for debugging the virtualized system

**setup_env.cmm** is to be used with Trace32 and a Lauterbach PowerDebug PRO JTAG hardware debugger. The hardware debugger has been connected to the JTAG port (J180) of the ZCU104. **setup_env.cmm** provides a complete debugging environment of the virtualised systems, including the root cell and Jailhouse.  The script is used to observe the SDHC control registers, MMU and SMMU page tables and confirm the effectiveness of the attack.

### Some usages of the debugger for observing the attack :

- Check what memory VMs can access (Stage 2 translation)
- Check what memory DMA-capable devices assigned to VM can access (SMMU)
- Break in the hypervisor and understand how Stream ID are reallocated upon VM destruction
- Check the SDHC's state

### Files to be imported from the building directory

**vmlinux**: Debugging the Linux in the Root Cell (OS awareness)

​	Location: $JH_WD/rootcell/linux/

**hypervisor.o**: Debugging Jailhouse hypervisor at EL2 (Hypervisor awareness)

​	Location: $JH_WD/jailhouse/hypervisor/

**jailhouse.ko**: Debugging Jailhouse hypervisor kernel module at EL1 in the Root Cell

​	Location: $JH_WD/jailhouse/driver/



