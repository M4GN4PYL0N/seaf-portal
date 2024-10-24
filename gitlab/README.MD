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
В тестовой инсталляции используется DNS имя **git.archportal.local**

3. Запустите контейнер
``` shell
cd gitlab
docker-compose up -d
```
Сервис поднимается довольно долго, поэтому имеет смысл проверять состояние
``` shell
docker ps 
```
Далее необходимо настроить репозиторий. Чтобы залогиниться в первый раз потребуется получить пароль.

## Дефолтный логин и пароль
Логин: root

Пароль:
``` shell
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```

## Настройка репозитория
1. Создайте Acccess token, для этого перейдите в Edit profile -> Access tokens
   ![img.png](images/img.png)

2. Сохраните токен для последующей конфигурации SEAF Portal
   Токен необходимо задать в секции environment ../docker-compose.yaml **VUE_APP_DOCHUB_PERSONAL_TOKEN:**

3. Создайте новую группу
   ![img_1.png](images/img_1.png)

4. Создайте проект в группе
   ![img_2.png](images/img_2.png)

5. Скопируйте идентификатор проекта в разделе Settings -> General 
   ![img_3.png](images/img_3.png)

## Настройте параметры подключения в SEAF Portal
В секции environment ../docker-compose.yaml (в корне проекта)
``` yaml
VUE_APP_DOCHUB_GITLAB_URL: https://git.archportal.local/
VUE_APP_DOCHUB_ROOT_MANIFEST: gitlab:5:main@root.yaml        # Файл и импортами
VUE_APP_DOCHUB_PERSONAL_TOKEN: glpat-zU_eqeie5Vb5mxtHsmPL
```
## Создайте тестовые данные
В корне репозитория создайте следующие файлы:
 - root.yaml
``` yaml
imports:
   - documents.yaml
```
- documents.yaml
``` yaml
docs:
    superdoc.congrats:                         # Идентификатор документа
        icon: lightbulb_outline              # Иконка, которы будет отображаться в дереве навигации
        location: DocHub/Тестовый документ   # Размещение документа в меню (если требуется отражать)
        description: Тестовый документ       # Краткое описание сути документа (опиционально)
        type: markdown                # Тип документа (OpenAPI / markdown / PlantUML / Table)
        source: manual.md 
```
- manual.md
``` markdown
# Тестовый документ
Поздравляем, вы настроили SEAF Portal.
```