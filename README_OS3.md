1. Какой системный вызов делает команда cd?

	'''
	vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp'
	chdir("/tmp")
	'''

2. Используя strace выясните, где находится база данных file, на основании которой она делает свои догадки.

	'''
	vagrant@vagrant:~$ strace file /bin/bash
	stat("/home/vagrant/.magic.mgc", 0x7ffeebedcfd0) = -1 ENOENT (No such file or directory)
	stat("/home/vagrant/.magic", 0x7ffeebedcfd0) = -1 ENOENT (No such file or directory)
	openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
	'''

3. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

<<<<<<< HEAD
	'''
=======
	```
>>>>>>> 3df70e64d1597ccc1fca989a623fea0be105de36
	vagrant@vagrant:~$ ping 127.0.0.1 >test &
	[1] 1661
	vagrant@vagrant:~$ rm test
	vagrant@vagrant:/$ sudo lsof -p 1661 | grep del
	ping    1661 vagrant    1w   REG  253,0    58882 1316908 /home/vagrant/test (deleted)
	
	root@vagrant:/# echo '' > /proc/1661/fd/1
	
	root@vagrant:/# sudo truncate -s 0 /proc/1661/fd/
	
	vagrant@vagrant:/$ sudo cat /proc/1661/fd/1 > /dev/null
	
	vagrant@vagrant:/$ sudo lsof -p 1661 | grep del
	ping    1661 vagrant    1w   REG  253,0   307102 1316908 /home/vagrant/test (deleted)
	
<<<<<<< HEAD
	Попробовал разные варианты, которые нагуглил, но размер файла продолжает увеличиваться. В итоге смог остановить только через kill.
	'''
=======
	vagrant@vagrant:/$ sudo kill 1661
	vagrant@vagrant:/$ sudo lsof | grep del
	```
>>>>>>> 3df70e64d1597ccc1fca989a623fea0be105de36

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

	'''
	Не занимают
	'''

5. На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты?

	'''
	vagrant@vagrant:~$ sudo opensnoop-bpfcc
	PID    COMM               FD ERR PATH
	377    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.procs
	377    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.threads
	859    vminfo              5   0 /var/run/utmp
	619    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
	619    dbus-daemon        21   0 /usr/share/dbus-1/system-services
	619    dbus-daemon        -1   2 /lib/dbus-1/system-services
	619    dbus-daemon        21   0 /var/lib/snapd/dbus-1/system-services/
	'''

6. Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.

	'''
	vagrant@vagrant:~$ strace uname -a
	execve("/usr/bin/uname", ["uname", "-a"], 0x7ffc9cdc3a38 /* 23 vars */) = 0
	
	/proc/version
        This  string  identifies  the  kernel version that is currently running.  It includes the contents of /proc/sys/kernel/ostype, /proc/sys/kernel/osrelease and
        /proc/sys/kernel/version.  For example:
        Linux version 1.0.9 (quinlan@phaze) #1 Sat May 14 01:51:54 EDT 1994

	'''

7. Чем отличается последовательность команд через ; и через && в bash? Есть ли смысл использовать в bash &&, если применить set -e?

	'''
	; - разделяет команды, выполнение происходит по очереди
	&& - логический оператор, вывод Hi не произойдёт, т.к. значение первой части ложь
	set -e завершает работу, если результат не нулевой. Одновременное использование не имеет смысла, т.к., если результат нулевой, то выполнение итак прекратится
	
	Алексей Федин:
	set -e имеет смысл использовать для команд разделенных &&, так как выход из скрипта в этом случае произойдет по последней команде, если она завершилась с ошибкой.
	В man это поведение описано: The shell does not exit if the command that fails is . . . part of any command executed in a && or || list except the command following the final &&
	'''

8. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?

	'''
	set -euxo pipefail is short for:
		set -e
		set -u
		set -o pipefail
		set -x

	Используется для получения скрытых ошибок
	'''

9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов.

	'''
	R    running or runnable (on run queue)
        S    interruptible sleep (waiting for an event to complete)
	'''
