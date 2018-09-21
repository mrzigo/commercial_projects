# Commercial Projects
### Плагин(Модуль) для redmine, который отмечает часть проектов маркером. Данные загружаются по URL в json-формате

## Установка

```
$ cd ...redmine/plugins/
$ git clone git@github.com:mrzigo/commercial_projects.git
$ cd ...redmine/ && rake redmine:plugins:migrate RAILS_ENV=production
# Перезапуск redmine
```

## Настройка
Авторизация в редмайн пользователем с правами адмнистратора, далее
```
Меню -> Администрирование -> Модули -> Commercial Projects (Параметры)
```
или перейти по ссылке:
your.redmine.host/settings/plugin/commercial_projects

Обязательно указать URL и значение status поля, которое является основнаием для маркировки проектов.

## Для загрузки данных нужно выполнять rake task:
```
bundle exec rake redmine:plugins:commercial_projects:download RAILS_ENV=production
```
Возможно команду необходимо добавить в crontab (На Ваше усмотрение)

## Дополнительная информация
пример формата json-файла
```
{
  "123": {
    "status": "key"
  },
  "321": { // project_id
    "status": "other"
  }
}
```

## Удаление

```
$ cd ...redmine/ && rake redmine:plugins:migrate NAME=commercial_projects VERSION=0 RAILS_ENV=production
$ rm -rf ...redmine/plugins/commercial_projects
# Перезапуск redmine
```
