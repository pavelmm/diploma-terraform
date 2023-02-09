# Yandex Object Storage + Terraform state

https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-state-storage#configure-terraform

https://www.terraform.io/language/settings/backends/s3

# Terraform Workspaces

https://www.terraform.io/language/state/workspaces - офф. дока

https://adamtheautomator.com/terraform-workspace/ - пример как создавать ресурсы для разных воркспейсов один манифестом, используя переменную `${terraform.workspace}`

https://www.padok.fr/en/blog/terraform-workspaces

# Atlantis

https://hub.docker.com/r/runatlantis/atlantis образ

https://github.com/runatlantis/atlantis GitHub

https://www.runatlantis.io/docs/deployment.html#kubernetes-manifests деплой в Кубер из манифестов

https://www.runatlantis.io/docs/configuring-webhooks.html#github-github-enterprise настройка хуков


[раз](https://stackoverflow.com/questions/43544370/kubernetes-how-to-set-volumemount-user-group-and-file-permissions)
[два](https://discuss.kubernetes.io/t/write-permissions-on-volume-mount-with-security-context-fsgroup-option/16524)
Решение ошибки `mkdir /atlantis/bin: Permission denied` - создать init контейнер, который смонтирует тот же раздел и поправит права на папку

Пример настроек Atlantis из 2-го модуля: 
- [atlantis.yaml](https://github.com/run0ut/devops-netology/blob/main/02-virt-homeworks/misc/74/atlantis.yaml)
- [server.yaml](https://github.com/run0ut/devops-netology/blob/main/02-virt-homeworks/misc/74/server/server.yaml)

Пример запуска с конфигом в JSON
```bash
docker-entrypoint.sh server --atlantis-url=http://178.154.204.124:30141/ --var-file-allowlist=/home/atlantis --tf-download-url=https://terraform-mirror.yandexcloud.net/ --repo-config-json='{"repos":[{"id":"/.*/","allowed_overrides":["workflow"],"allow_custom_workflows":true}]}' --log-level=info 
```
https://www.runatlantis.io/docs/server-configuration.html описание аргументов командной строки для запуска сервера

https://www.runatlantis.io/docs/server-side-repo-config.html#allow-repos-to-define-their-own-workflows конфигурация поведения Атлантиса по репозиториям, общий для всех конфиг; подраздел с описанием как разрешить переопределение конфига конфигом atlantis.yaml из препозитория

https://www.runatlantis.io/docs/repo-level-atlantis-yaml.html конфигурация поведения Атлантиса в конкретном репозитории

https://www.runatlantis.io/docs/custom-workflows.html#running-custom-commands примеры workflow, подраздел с примером как выполнять произвольные команды

# Jenkins

Пригодилось:

[Установка в Кубер](https://www.jenkins.io/doc/book/installing/kubernetes/#install-jenkins-with-yaml-files)

[Dockerfile для Jenkins в докере](https://github.com/jenkinsci/docker-workflow-plugin/blob/docker-workflow-1.12/demo/Dockerfile) - тут подсмотрел установку Докера в контейнер с Дженскинсом и добавление плагинов

[Билд образов, пуш в докер и использование креденшелз для docker login](https://www.liatrio.com/blog/building-with-docker-using-jenkins-pipelines)

[Youtube, решение подобной задачи со сборкой по коммиту](https://www.youtube.com/watch?v=0D_wKERZ2zo)

[Jenkinsfile из видео](https://github.com/ksemaev/project_template/tree/master/jenkinsfiles)

[Как сохоранить вывод sh в переменную](https://stackoverflow.com/questions/36547680/how-do-i-get-the-output-of-a-shell-command-executed-using-into-a-variable-from-j)

[Примеры пайплайнов](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps)

[Тригер пайплайнов при появлении тага](https://stackoverflow.com/questions/29742847/jenkins-trigger-build-if-new-tag-is-released)

----
Добавить комит и таг

```bash
tag_n=$(git tag --sort version:refname | tail -1 | cut -d . -f 3) && date +%s > dummy && git add . && tag_n=$((tag_n+1)) && git commit -m "tag $tag_n" && git tag v0.0.$tag_n && git push --tags origin main
```
Скачать jenkins-cli
```
curl http://localhost:8080/jnlpJars/jenkins-cli.jar -o jenkins-cli.jar
```
Выгрузить и загрузить креденшелы. Выгружаются без секретов.
```
java -jar jenkins-cli.jar -s http://localhost:8080 list-credentials-as-xml "system::system::jenkins" > jenkins-credentials.xml
java -jar jenkins-cli.jar -s http://localhost:8080 import-credentials-as-xml "system::system::jenkins" < jenkins-credentials.xml
```
---

Не пригодилось пока:

[Установка с оператором](https://jenkinsci.github.io/kubernetes-operator/docs/getting-started/latest/installing-the-operator/) (не исопльзовал)

[Docker pipeline](https://docs.cloudbees.com/docs/admin-resources/latest/plugins/docker-workflow) - не пригодилось, нет особой разницы между этим и `sh`, `docker cli` всё равно должна быть установлена

[Примеры билда контейнеров с Docker pipeline](https://www.jenkins.io/doc/book/pipeline/docker/#building-containers)

[credentials](https://citizix.com/using-jenkins-cli-to-manage-jenkins-jobs-and-credentials/)

# Git

Заготовка для создания репозитория автоматом
```
{
  git init 
  git add *tf {ansible,kubeconfig}/README.md templates/* README.md *yaml--force 
  git add .gitignore && git add .terraformrc
  git commit -m'first commit'
  git branch -M main 
  repo=diploma-terraform-`date +%s`
  curl -sS \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer <TOKEN>" \
    https://api.github.com/user/repos \
    -d '{"name":"'$repo'","description":"Netology DevOps cource diploma, test application","homepage":"https://github.com","private":false,"is_template":false}'
  git remote add origin git@github.com:${var.github_login}/$repo-${local.repocreatedatetime}.git 
  git push --set-upstream origin main
}
```

# Terraform

Создать локальную переменную таймстемпом, напримре для наполнения или имен фалйов и папок

locals {
  repocreatedatetime = formatdate("YYYYMMDDhhmmss", timestamp())
}