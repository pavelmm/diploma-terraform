# Предварительные настройки 

Необходимый софт:
- terraform
- ansible
- pip3
- git
- kubectl
- jq

Необходимые реквизиты:
- Аккаунт GitHub и Personal Access Token
- Аккаунт Docker Hub
- Аккаунт Yandex Cloud и Service Account, ключ авторизации сервисного аккаунта
- Закрытый и открытый ключ .ssh в `~/.ssh`

Что нужно настроить:
- Настройте git на локальной машине для работы с репозиториями в GitHub, должна быть возможность делать push по ключу ssh, без ввода пароля

# Как запустить

1. Зайдите в папку [00-bucket](00-bucket)
    - Заполните переменные [00-bucket/.auto.tfvars](00-bucket/.auto.tfvars)
    - Примените конфигурацию
        ```bash
        terraform init
        terraform apply -auto-approve
        ```
1. Зайдите в папку [01-yandex](01-yandex)
    - Инициализируйте Тераформ:
        ```bash
        terraform init
        ```
    - Создайте воркспейсы `stage` и `prod`:
        ```bash
        terraform workspace new stage
        terraform workspace new prod
        ```
    - Примените конфигурацию
        ```bash
        terraform workspace select stage 
        terraform apply -auto-approve
        terraform workspace select prod 
        terraform apply -auto-approve
        ```
1. После применения конфигурации prod, Terraform выведет ссылки на все ресурсы, которые должны быть доступны извне: приложение, Grafana, Atlantis, Jenkins.

    Приблизительно так должен выглядеть вывод:
    ```console
    Apply complete! Resources: 28 added, 0 changed, 0 destroyed.

    Outputs:

    control_nodes = [
    "name=diploma-control-prod-0, public=51.250.12.74, private=10.0.0.12",
    ]
    links = <<EOT
        App: http://51.250.12.74:30080
    Jenkins: http://51.250.12.74:30808
    Atlantis: http://51.250.12.74:30141
    Grafana: http://51.250.12.74:30300

    EOT
    worker_nodes = [
    "name=diploma-worker-prod-0, public=51.250.12.74, private=10.0.0.19",
    ]
    ```

    Приложение пока будет недоступно. Оно будет работать, когда поднимется Jenkins, соберёт первый билд и отправит в Docker Hub.

1. Зайдите в папку [02-app](02-app):
    - Выполните скрипт, чтобы создать теги и отправить их в репозиторий:
        ```bash
        {
            tag_n=0
            date +%s > dummy
            git add dummy 
            tag_n=$((tag_n+1))
            git commit -m "tag $tag_n"
            git tag v0.0.$tag_n
            git push --tags origin main
        }
        ```
    - Через пару минут проверьте, что Jenkins собрал докер-образы и отправил в Docker Hub


## Возможно потребуется создать докер-контейнер Jenkins с плагинами

Для задания был подготовлен докер-контейнер с Jenkins с нужными плагинами. Если со временем я его удалю, то вначале нужно будет сделать собственный. Это нужно делать вначале, иначе не получится автоматический развренуть Jenkins.

1. Зайдите в папку [05-jenkins](05-jenkins), запустите jenkins с docker-compose, 
1. Пройдите шаги мастера, подождите когда установятся планигы
1. Добавьте плагин [Basic Branch Build Strategies Plugin](https://github.com/jenkinsci/basic-branch-build-strategies-plugin)
1. Содержимое папки `data/plugins` положите в [05-jenkins/plugins](05-jenkins/plugins)
1. Создайте docker контейнер, отправьте в DockerHub
1. Поправьте image в [manifests/00-deployment.yml](manifests/00-deployment.yml) на созданный Вами
