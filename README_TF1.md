### Чеклист готовности к домашнему заданию

1. Скачайте и установите актуальную версию **terraform** (не менее 1.3.7). Приложите скриншот вывода команды ```terraform --version```.
2. Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.
3. Убедитесь, что в вашей ОС установлен docker.

![TF_version](https://github.com/SergeyKorchak/devops-netology/assets/119151349/77b4991d-126d-47b0-a87e-4f6a51f31c72)

------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 
2. Изучите файл **.gitignore**. В каком terraform файле допустимо сохранить личную, секретную информацию?

```
Секретную информацию можно хранить в файле personal.auto.tfvars.
```

3. Выполните код проекта. Найдите  в State-файле секретное содержимое созданного ресурса **random_password**. Пришлите его в качестве ответа.

```
SUv10zMKrYqUTjJG
```

4. Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла **main.tf**.
Выполните команду ```terraform validate```. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.

```
sergey@pc:~/Terraform$ terraform validate
╷
│ Error: Invalid resource name
│ 
│   on main.tf line 30, in resource "docker_container" "1nginx":
│   30: resource "docker_container" "1nginx" {
│ 
│ A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.

sergey@pc:~/Terraform$ terraform validate
╷
│ Error: Reference to undeclared resource
│ 
│   on main.tf line 31, in resource "docker_container" "nginx":
│   31:   image = docker_image.nginx.image_id
│ 
│ A managed resource "docker_image" "nginx" has not been declared in the root module.

sergey@pc:~/Terraform$ terraform validate
╷
│ Error: Missing name for resource
│ 
│   on main.tf line 23, in resource "docker_image":
│   23: resource "docker_image" {
│ 
│ All resource blocks must have 2 labels (type, name).
╵
sergey@pc:~/Terraform$ terraform validate
Success! The configuration is valid.
```

5. Выполните код. В качестве ответа приложите вывод команды ```docker ps```

```
sergey@pc:~/Terraform$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS         PORTS                  NAMES
3ba5b47b10d2   904b8cb13b93   "/docker-entrypoint.…"   12 seconds ago   Up 8 seconds   0.0.0.0:8000->80/tcp   example_SUv10zMKrYqUTjJG
```

6. Замените имя docker-контейнера в блоке кода на ```hello_world```, выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чем может быть опасность применения ключа  ```-auto-approve``` ?

```
Использование auto-approve опасно, так как изменения применяются в инфраструктуре без акцепта пользователя.

sergey@pc:~/Terraform$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
63c9603b3270   904b8cb13b93   "/docker-entrypoint.…"   5 seconds ago   Up 3 seconds   0.0.0.0:8000->80/tcp   hello_world

```

8. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**.

```
{
  "version": 4,
  "terraform_version": "1.4.6",
  "serial": 11,
  "lineage": "9e3c243b-1e55-ed89-5641-cf6bf9589e0c",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```

9. Объясните, почему при этом не был удален docker образ **nginx:latest** ?(Ответ найдите в коде проекта или документации)

```
Не был удален, так как в main указано keep_locally = true.
```
