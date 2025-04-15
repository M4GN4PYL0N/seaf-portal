# Параметры

Для настройки реверса VMware vSphere создайте соответсвующий блок настроек в config/variables.json

```json
"vcenters": [
        {
            "vmuser": "vmuser",
            "vmpassword": "vmpassword",
            "vmhost": "xxx.xxx.xxx.xxx",
            "prefix": "company.dc.",
            "location": "company.dc",
            "output": "/var/lib/airflow/output/vc1",
            "git_push_script": "/scripts/git_push_split_repo.sh",
            "git_user": "git_user",
            "git_token": "git_token",
            "git_commit_user": "имя отображаемое в комитах",
            "git_commit_email": "email отображаемый в комитах",
            "git_clone": "git link",
            "git_project": "git project",
            "git_branch": "branch name"
        }
]
```
Где,
vmuser: "vmuser" - название переменной в AirFlow c логином для VCenter
vmpassword: "vmpassword" - название переменной в AirFlow c паролем для VCenter
vmhost: "xxx.xxx.xxx.xxx" - ip адрес или FQDN VCenter
prefix: "company" - префикс компании
location: "company.dc" - Идентификатор сущности датацентра/iaas услуги/тенанта (нужно создать соответствующий объект сущности seaf.ta.services.dc)
output: "/var/lib/airflow/output/vc1" - папка куда выгружается конфигурация на хосте с AirFlow
git_push_script: "/scripts/git_push_split_repo.sh" - скрипт который выполняется для push
git_user: "git_user" - название переменной в AirFlow где будет храниться логин Gitlab
git_token: "git_token" - название переменной в AirFlow где будет храниться токен от Gitlab
"git_commit_user": "имя отображаемое в комитах"
"git_commit_email": "email отображаемый в комитах"
git_clone: "git link" - ссылка на репозиторий (для git clone)
git_project: "git project" - название проекта/репозитория
git_branch: "branch name" - ветка репозитория
