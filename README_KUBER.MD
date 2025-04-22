# Развертывание SEAF ArchPortal на в Kubernetes

1. Качаем репозиторий по ссылке gitverse
[Репозиторий SEAF ArchTool](https://gitverse.ru/seafteam/seaf-archtool-core/releases/tag/v3.15.1)

2. Делаем build с указанием нужных env

3. Полученный образ отправляем в наш registry

4. Качаем helm-chart здесь * *

5. Выполняем установку
helm install seaf-archportal ./seaf-archportal \
  --set image.repository=your.registry/seaf-archportal \
  --set image.tag=1.0.0

6. Создаем пользователя archtool в **gitlab** и создаем ему токен (предполагается, что Gitlab у вас уже развернут)

7. Добавляем пользователя **archtool** в проект, где лежит конфигурация (имеется в виду инфраструктура, которая будет отображаться в ui)

8. Блок связанный с keycloak валиден [здесь](keycloak/README.MD)

9. Наполняем .env файл (в примере для подключения ролевой модели)

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

10. Берем helm-chart здесь https://github.com/RabotaRu/helm-charts/tree/main/charts/dochub и меняем порт внутри deployment.yaml на 3030, также в values.yaml меняем порт внутри блока service на 3030
