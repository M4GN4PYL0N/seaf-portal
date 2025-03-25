# Развертывание SEAF ArchPortal на в Kubernetes

1. Качаем репозиторий по ссылке gitverse
[Репозиторий SEAF ArchTool](https://gitverse.ru/seafteam/seaf-archtool-core/releases/tag/v3.15.1)

2. Создаем пользователя archtool в **gitlab** и создаем ему токен (предполагается, что Gitlab у вас уже развернут)

3. Добавляем пользователя **archtool** в проект, где лежит конфигурация (имеется в виду инфраструктура, которая будет отображаться в ui)

4. Блок связанный с keycloak валиден [здесь](keycloak/README.MD)

5. Наполняем .env файл (в примере для подключения ролевой модели)

``` shell
VUE_APP_DOCHUB_APPEND_DOCHUB_DOCS=n
VUE_APP_DOCHUB_ROLES_MODEL=y
VUE_APP_DOCHUB_ROLES=gitlab_url до roles.yaml или путь к локальной директории внутри
VUE_APP_DOCHUB_AUTHORITY_SERVER=keycloak_url VUE_APP_DOCHUB_AUTHORITY_CLIENT_ID=client id from keycloak
VUE_APP_DOCHUB_AUTH_PUBLIC_KEY=rsa key from keycloak
VUE_APP_DOCHUB_GITLAB_URL=gitlab url
VUE_APP_DOCHUB_PERSONAL_TOKEN=dochub_user_token
VUE_APP_DOCHUB_ROOT_MANIFEST=gitlab project manifest
```

6. Берем helm-chart здесь https://github.com/RabotaRu/helm-charts/tree/main/charts/dochub и меняем порт внутри deployment.yaml на 3030, также в values.yaml меняем порт внутри блока service на 3030
