# Развертывание SEAF ArchPortal

В данном сценарии описывается развертывание портала SEAF вместе с Keycloak и Gitlab. Сценарий можно адаптировать под развертывание в промышленных средах.
## Все на одной машине
На одной машине будут развернуты контейнеры SEAF Archtool, PlantUML, Keycloak (postgres), Gitlab и Reverse-Proxy на NGINX.

| Контейнер     | Порты и протоколы            |
|---------------|------------------------------|
| seaf-backend  | tcp/8080                     |
| plantuml      | tcp/8079                     |   
| keycloak      | tcp/8443, tcp/9000, tcp/8081 |
| gitlab        | tcp/8929, tcp/8083, tcp/2424 |
| postgres      | tcp/5432                     |
| reverse-proxy | tcp/80, tcp/443              |

### Подготовка к развертыванию
1. Создайте FQDN для сервисов ниже и зарегистрируйте на вашем DNS сервере

| Контейнер    | FQDN (пример)        |
|--------------|----------------------|
| seaf-backend | archportal.local     |
| keycloak     | aaa.archportal.local |   
| gitlab       | git.archportal.local |

2. Создайте и подпишите на вашем CA сертификаты для каждого FQDN. 
Для тестового развертывания мы создадим wildcard сертификат для домена archportal.local
```shell
# Зададим наш домен
DOMAIN=test.local
# Перейдем в папку с сертификатами
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
```
3. Теперь у нас есть сертификаты и можно поднимать наши сервисы. Начнем с keykloak

4. sdsd