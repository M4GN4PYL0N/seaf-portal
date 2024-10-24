# Настройка realm и клиента

1. Войти в консоль Keycloak с дефолтным логином и паролем указанным в keycloak.env
2. Создайте realm который будет указан в секции environment ../docker-compose.yaml **VUE_APP_DOCHUB_AUTHORITY_SERVER:**
   В тестовом сценарии создается realm **archportal**
   ![img.png](images/img.png)
   ![img_1.png](images/img_1.png)
3. Перейдите в раздел clients и создайте нового клиента. В данной конфигурации клиент также называется archportal и задается в секции environment ../docker-compose.yaml **VUE_APP_DOCHUB_AUTHORITY_CLIENT:**
   ![img_2.png](images/img_2.png)
   ![img_3.png](images/img_3.png)
   ![img_4.png](images/img_4.png)
   ![img_5.png](images/img_5.png)
4. Перейдите в раздел Roles и создайте роль. Роли в SEAF портале задаются в файле ../seaf-backend/roles/roles.yaml а подключаются в секции environment ../docker-compose.yaml **VUE_APP_DOCHUB_ROLES:**
   ![img_6.png](images/img_6.png)
   ![img_7.png](images/img_7.png)
5. Далее создадим пользователя, добавим ему роль которую создали на шаге 4 и зададим пароль
   ![img_8.png](images/img_8.png)
   ![img_9.png](images/img_9.png)
   ![img_10.png](images/img_10.png)
   ![img_11.png](images/img_11.png)
   ![img_12.png](images/img_12.png)
   ![img_13.png](images/img_13.png)
6. Далее необходимо скопировать RSA ключ для подписи запросов. Для этого перейдем в раздел Realm Settings -> Keys и скопируем RS256 Public key
   ![img_14.png](images/img_14.png)
7. Скопированный ключ необходимо вставить между блоками ----BEGIN PUBLIC KEY-----{_ваш ключ_}-----END PUBLIC KEY------ в секции environment ../docker-compose.yaml **VUE_APP_DOCHUB_AUTH_PUBLIC_KEY:**