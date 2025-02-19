# Ролевая модель SEAF.ArchTool

Ниже опишем принцип создания ролевой модели для SEAF.ArchTool

Ролевая модель построена на регулярных выражениях которые фильтруют озеро данных по вхождениям ключей.
Включение ролевой модели выполняется переменной:
```properties
VUE_APP_DOCHUB_ROLES_MODEL=(y/n) - включена/выключена
```
При включении ролевой модели обязательно должна быть настроена аутентификация с помощью OIDC провайдера, выполняется в параметрах:
```properties
VUE_APP_DOCHUB_AUTHORITY_SERVER=(url провайдера учетных записей)
VUE_APP_DOCHUB_AUTHORITY_CLIENT_ID=(идентифкатор клиента)
VUE_APP_DOCHUB_AUTH_PUBLIC_KEY=-----BEGIN PUBLIC KEY-----.......-----END PUBLIC KEY----- - (Token Signing Key)
```

Непосредственно роли задаются в конфигурационных файлах roles.yaml и default.yaml (должен находиться в той же директории что и roles.yaml).
Файл с ролями подключается следующей переменной:
```properties
VUE_APP_DOCHUB_ROLES=file:///roles/roles.yaml - задается путь относительно папки public
```
В файле **roles.yaml** задаются все ключи которые разрешены для роли, в секции default перечислены ключи доступные пользователю не прошедшему аутентификацию. **Роль не может быть пустой, обязательно оставляйте в роли какое-то регулярное выражение!**
Ниже пример файла с ролями:
```yaml
users:
  - '^entities$'
  - '^docs$'
  - '^presentations$'
  - '^(location|title|description|config|root_menu|source|schema|type|patternProperties|properties|icon|subjects|template|anyOf|pattern|"$ref")$'
  - '^menu$'
  - '^dochub.*$'
default:
  - '^entities$'
  - '^docs$'
  - '^dochub\.welcome$'
  - '^(template|title|type)$'
```
Где,
**default** - полномочия доступные пользователю не прошедшему аутентификацию
**users** - полномочия пользователя с ролью **users**

Рассмотрим на примере:
```yaml
entities:
  docs:
    title: Документы
    config:
      root_menu: Документы
    menu: >
      (
        код вашего меню
      )
    schema:
      type: object
      patternProperties:
        "^[0-9a-zA-Z][a-zA-Z0-9_-]*(\\.[a-zA-Z][a-zA-Z0-9_-]*)*$":
          type: object
          properties:
            title:
              title: Название документа
              type: string
            location:
              title: Место расположения в меню
              type: string
            icon:
              title: Иконка в меню
              type: string
            type:
              title: Тип документа
              type: string
            subjects:
              title: Принадлежит объектам
              type: array
              items:
                type: string
            template:
              title: Путь к файлу шаблона
              type: string
            source:
              title: Источник данных (документ, объект, запрос или dataset)
              anyOf:
                - type: string
                  title: Идентификатор dataset
                  pattern: "^[0-9a-zA-Z][a-zA-Z0-9\_]*(\\.[a-zA-Z][a-zA-Z0-9\\_]*)*$"
                - type: string
                  title: JSONata запрос
                  pattern: "\\s*\\((.|\\s)*\\)\\s*"
                - title: Ссылка на документ
                  "$ref": "#/$defs/$res-uri-reference"
                - title: Объект
                  type: object
                - title: Массив
                  type: array
      additionalProperties: false
docs: 
  dochub.welcome:
    title: Приветсвенный документ
    location: Документ
    type: markdown
    template: doc.md
```
Для роли **users**, с учетом приведенного выше примера, останется весь манифест, а для роли **default** манифест сократится до:
```yaml
entities:
  docs:
    title: Документы
docs: 
  dochub.welcome:
    title: Приветственный документ
    type: markdown
    template: doc.md
```
Как видим остаются только те ключи, что попадают под наши регулярные выражения.

docs:
    meta:
        title: Dasad
        type: 