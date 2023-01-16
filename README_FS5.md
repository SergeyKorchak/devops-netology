1. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

	```
	Не могут, т.к. права и владелец определены однозначно.
	```

2. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile.

	```
	sergey@pc:~/devops$ vagrant destroy
	    default: Are you sure you want to destroy the 'default' VM? [y/N] y
	==> default: Forcing shutdown of VM...
	==> default: Destroying VM and associated drives...
	```

3. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

	```
	vagrant@sysadm-fs:~$ sudo fdisk /dev/sdb
	
	Welcome to fdisk (util-linux 2.34).
	Changes will remain in memory only, until you decide to write them.
	Be careful before using the write command.
	
	Device does not contain a recognized partition table.
	Created a new DOS disklabel with disk identifier 0xf13e7868.
	
	Command (m for help): n
	Partition type
	   p   primary (0 primary, 0 extended, 4 free)
	   e   extended (container for logical partitions)
	Select (default p): p
	Partition number (1-4, default 1): 1
	First sector (2048-5242879, default 2048): 
	Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G
	
	Created a new partition 1 of type 'Linux' and of size 2 GiB.
	
	Command (m for help): n
	Partition type
	   p   primary (1 primary, 0 extended, 3 free)
	   e   extended (container for logical partitions)
	Select (default p): p
	Partition number (2-4, default 2): 2
	First sector (4196352-5242879, default 4196352): 
	Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879): 
	
	Created a new partition 2 of type 'Linux' and of size 511 MiB.
	
	Command (m for help): w
	The partition table has been altered.
	Calling ioctl() to re-read partition table.
	Syncing disks.
	```

4. Используя sfdisk, перенесите данную таблицу разделов на второй диск.

	```
	vagrant@sysadm-fs:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc
	Checking that no-one is using this disk right now ... OK
	
	Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
	Disk model: VBOX HARDDISK   
	Units: sectors of 1 * 512 = 512 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	
	>>> Script header accepted.
	>>> Script header accepted.
	>>> Script header accepted.
	>>> Script header accepted.
	>>> Created a new DOS disklabel with disk identifier 0xf13e7868.
	/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
	/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
	/dev/sdc3: Done.
	
	New situation:
	Disklabel type: dos
	Disk identifier: 0xf13e7868
	
	Device     Boot   Start     End Sectors  Size Id Type
	/dev/sdc1          2048 4196351 4194304    2G 83 Linux
	/dev/sdc2       4196352 5242879 1046528  511M 83 Linux
	
	The partition table has been altered.
	Calling ioctl() to re-read partition table.
	Syncing disks.
	```

5. Соберите mdadm RAID1 на паре разделов 2 Гб.

	```
	agrant@sysadm-fs:~$ sudo mdadm --create /dev/md1 -l 1 -n 2 /dev/sd{b1,c1}
	mdadm: Note: this array has metadata at the start and
	    may not be suitable as a boot device.  If you plan to
	    store '/boot' on this device please ensure that
	    your boot-loader understands md/v1.x metadata, or use
	    --metadata=0.90
	Continue creating array? y
	mdadm: Defaulting to version 1.2 metadata
	mdadm: array /dev/md1 started.
	```
	
6. Соберите mdadm RAID0 на второй паре маленьких разделов.

	```
	vagrant@sysadm-fs:~$ sudo mdadm --create /dev/md0 -l 0 -n 2 /dev/sd{b2,c2}
	mdadm: Defaulting to version 1.2 metadata
	mdadm: array /dev/md0 started.
	```

7. Создайте 2 независимых PV на получившихся md-устройствах.

	```
	vagrant@sysadm-fs:~$ sudo pvcreate /dev/md0 /dev/md1
	  Physical volume "/dev/md0" successfully created.
	  Physical volume "/dev/md1" successfully created.
	```

8. Создайте общую volume-group на этих двух PV.

	```
	vagrant@sysadm-fs:~$ sudo vgcreate vg01 /dev/md0 /dev/md1
	  Volume group "vg01" successfully created
	```

9. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

	```
	vagrant@sysadm-fs:~$ sudo lvcreate -L 100M vg01 /dev/md0
	  Logical volume "lvol0" created.
	```

10. Создайте mkfs.ext4 ФС на получившемся LV.

	```
	vagrant@sysadm-fs:~$ sudo mkfs.ext4 /dev/vg01/lvol0
	mke2fs 1.45.5 (07-Jan-2020)
	Creating filesystem with 25600 4k blocks and 25600 inodes
	
	Allocating group tables: done                            
	Writing inode tables: done                            
	Creating journal (1024 blocks): done
	Writing superblocks and filesystem accounting information: done
	```

11. Смонтируйте этот раздел в любую директорию, например, /tmp/new.

	```
	vagrant@sysadm-fs:~$ mkdir /tmp/new
	vagrant@sysadm-fs:~$ sudo mount /dev/vg01/lvol0 /tmp/new
	```

12. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

	```
	vagrant@sysadm-fs:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
	```

13. Прикрепите вывод lsblk.

	```
	vagrant@sysadm-fs:~$ lsblk
	NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
	loop0                       7:0    0   62M  1 loop  /snap/core20/1611
	loop1                       7:1    0 67.8M  1 loop  /snap/lxd/22753
	loop3                       7:3    0 49.8M  1 loop  /snap/snapd/17950
	loop4                       7:4    0 63.3M  1 loop  /snap/core20/1778
	loop5                       7:5    0 91.9M  1 loop  /snap/lxd/24061
	sda                         8:0    0   64G  0 disk  
	├─sda1                      8:1    0    1M  0 part  
	├─sda2                      8:2    0    2G  0 part  /boot
	└─sda3                      8:3    0   62G  0 part  
	  └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm   /
	sdb                         8:16   0  2.5G  0 disk  
	├─sdb1                      8:17   0    2G  0 part  
	│ └─md1                     9:1    0    2G  0 raid1 
	└─sdb2                      8:18   0  511M  0 part  
	  └─md0                     9:0    0 1018M  0 raid0 
	    └─vg01-lvol0          253:1    0  100M  0 lvm   /tmp/new
	sdc                         8:32   0  2.5G  0 disk  
	├─sdc1                      8:33   0    2G  0 part  
	│ └─md1                     9:1    0    2G  0 raid1 
	└─sdc2                      8:34   0  511M  0 part  
	  └─md0                     9:0    0 1018M  0 raid0 
	    └─vg01-lvol0          253:1    0  100M  0 lvm   /tmp/new
	```

14. Протестируйте целостность файла.

	```
	root@sysadm-fs:~# gzip -t /tmp/new/test.gz
	root@sysadm-fs:~# echo $?
	0
	```

15. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

	```
	root@sysadm-fs:~# pvmove /dev/md0 /dev/md1
	  /dev/md0: Moved: 12.00%
	  /dev/md0: Moved: 100.00%
	```

16. Сделайте --fail на устройство в вашем RAID1 md.

	```
	root@sysadm-fs:~# mdadm /dev/md1 --fail /dev/sdb1
	mdadm: set /dev/sdb1 faulty in /dev/md1
	```

17. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.

	```
	root@sysadm-fs:~# dmesg | grep md1
	[ 4907.065102] md/raid1:md1: not clean -- starting background reconstruction
	[ 4907.065107] md/raid1:md1: active with 2 out of 2 mirrors
	[ 4907.065153] md1: detected capacity change from 0 to 2144337920
	[ 4907.070278] md: resync of RAID array md1
	[ 4918.250336] md: md1: resync done.
	[ 6902.240671] md/raid1:md1: Disk failure on sdb1, disabling device.
	               md/raid1:md1: Operation continuing on 1 devices.
	```

18. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

	```
	root@sysadm-fs:~# gzip -t /tmp/new/test.gz
	root@sysadm-fs:~# echo $?
	0
	```

19. Погасите тестовый хост, vagrant destroy.

	```
	sergey@pc:~/devops$ vagrant destroy
	    default: Are you sure you want to destroy the 'default' VM? [y/N] y
	==> default: Forcing shutdown of VM...
	==> default: Destroying VM and associated drives...
	```
