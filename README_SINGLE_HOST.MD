# Развертывание SEAF ArchPortal на одной машине (Docker Desktop и т.п.)

В данном сценарии описывается развертывание портала SEAF вместе с Keycloak и Gitlab.
На одной машине будут развернуты контейнеры SEAF Archtool, PlantUML, Keycloak (postgres), Gitlab и Reverse-Proxy на NGINX.

Взаимодействие между компонентами реализовано по внутренней сети docker.

| Контейнер     | Порты и протоколы            |
|---------------|------------------------------|
| seaf-backend  | tcp/3030 (archtool network)  |
| plantuml      | tcp/8080 (archtool network)  |
| keycloak      | tcp/8080 (archtool network)  |
| gitlab        | tcp/8929, tcp/8083, tcp/2424 |
| reverse-proxy | tcp/80, tcp/443              |

## Подготовка к развертыванию

1. Добавьте в /etc/hosts адреса по которым будут доступны компоненты решения, пример ниже в таблице.

| Контейнер    | FQDN (пример)             |
|--------------|---------------------------|
| seaf-backend | archportal.local          |
| keycloak     | keycloak.archportal.local |
| gitlab       | git.archportal.local      |

2. Настройте параметры логирования Docker

```shell
sudo nano /etc/docker/daemon.json
{
    "userns-remap": "",
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "12m",
        "max-file": "3"
    }
}
```

3. Настройте параметры Docker Desktop (если используете его)

General -> Choose file sharing implementation for your containers -> gRPC FUSE

4. Склонируйте данный репозиторий и инициализируйте сабмодули

```shell
git clone https://github.com/mtrhnv/seaf-portal.git

cd seaf-portal

git submodule init && git submodule update --recursive
```

5. Создайте и подпишите на вашем CA сертификаты для каждого FQDN.

Для тестового развертывания мы создадим самоподписанный wildcard сертификат для домена **archportal.local**

**В консоли перейдите в корень клонированного репозитория!**

```shell
# Зададим наш домен
DOMAIN=archportal.local
# Создадим и перейдем в папку с сертификатами
mkdir certs
cd certs
# Создадим конфигурационный файл
cat > openssl.conf << EOF
[CA_default]
copy_extensions = copy

[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = req_distinguished_name
x509_extensions = v3_ca

[req_distinguished_name]
C = RU
ST = Moscow
L = Moscow
O = Lazy Arch Inc
OU = IT
emailAddress = it@nowhere.earth
CN = $DOMAIN

[v3_ca]
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
subjectKeyIdentifier = hash
subjectAltName = @alternate_names

[alternate_names]
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
EOF
# Сгенерируем сертификаты
openssl req -x509 -newkey rsa:2048 -sha256 -utf8 -days 365 -nodes \
    -config ./openssl.conf \
    -keyout ./server.key \
    -out ./server.crt

cd ..
cp certs/server.crt certs/server.key ./reverse-proxy/certs
```

Теперь у нас есть сертификаты и можно поднимать наши сервисы.

6. Внесите созданные в п.1 адрес а в следующие конфигурационные файлы:

* ./docker-compose_single_host.yaml - в разделе настроек gitlab
* ./keycloak/env/keycloak_single_host.env
* ./reverse-proxy/env/nginx.env

7. Запускаем решение командой

``` shell
docker-compose --file docker-compose_single_host.yaml up -d
```

Далее необходимо настроить Keycloak и Gitverse по инструкциям из [основного](README.MD) раздела и внести соответсвующие настройки в ./.env

8. Пересобираем контейнер seaf-backend после того как настроены сервисы и внесены параметры в ./.env

Откройте ./gitlab/docker-compose.yaml и укажите корректный external_url

``` shell
docker-compose --file docker-compose_single_host.yaml stop seaf-backend
docker-compose --file docker-compose_single_host.yaml build seaf-backend
docker-compose --file docker-compose_single_host.yaml up -d
```
