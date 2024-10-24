# Развертывание Gitlab
1. Перейдите в каталог ./gitlab
2. В файле docker-compose укажите корректное DNS имя  которое вы зарегистрировали в предыдущем разделе
``` yaml
    ...
    hostname: 'git.archportal.local'
    ...
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'https://git.archportal.local'
```
В тестовой инсталляции используется имя git.archportal.local
3. Запустите контейнер
``` shell
docker-compose up -d
```
Сервис поднимается довольно долго, поэтому имеет смысл проверять состояние
``` shell
docker ps 
```
Далее необходимо настроить репозиторий. Чтобы залогиниться в первый раз потребуется получить пароль, команда ниже в этой инструкции.

## Дефолтный логин и пароль
Логин: root
Пароль:
``` shell
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```