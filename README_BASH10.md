## Задание 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b  | В c будет a+b, т.к. не передаются не значения переменных |
| `d`  | 1+2  | В d будет сумма значений переменных a, b, знака +, но также по умолчанию строкой, сложения чисел не произойдет |
| `e`  | 3  | В e передается арифметическая сумма чисел из переменных, т.к. выражение взято в скобки и указан $ |

----

## Задание 2

На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```

### Ваш скрипт:
```bash
while ((1==1))
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	else
		break
	fi
done
```

---

## Задание 3

Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
for i in 192.168.0.1, 173.194.222.113, 87.250.250.242
do
	for j in {1..5}
	do
		nc -z $i 80
		echo $? $i >> curl.log
	done
done
```

---
## Задание 4

Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
while ((1==1))
do
	for i in 192.168.0.1, 173.194.222.113, 87.250.250.242
	do
		for j in {1..5}
		do
			nc -z $i 80
			if ($? != 0)
			then
				echo $? $i >> curl.log
			else
				echo $? $i >> error.log
				break
			fi
		done
	done
done
```

---