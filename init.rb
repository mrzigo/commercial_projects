CONF_ROLES = 'roles'
CONF_MARKER = 'marker'
CONF_URL = 'url'
CONF_CODE = 'code'
CONF_LAST = 'last_download'
CONF_PROJECT_IDS = 'project_ids'

Redmine::Plugin.register :commercial_projects do
  name 'Commercial Projects'
  author 'DigitalWand (mr.zigo@yandex.ru)'
  description 'Отображение информации о коммерческих проектах'
  version '0.1'
  url 'https://github.com/mrzigo/commercial_projects'
  author_url 'https://github.com/mrzigo'

  settings partial: 'commercial_projects/settings', default: {
    CONF_ROLES => [1, 2],                      # Для каких ролей скрываем стытусы проектов (по умолчанию "не участник" и "Аноним" не видят)
    CONF_MARKER => '(₽)',                      # Каким символом помечаем комерческие проекты
    CONF_URL => 'https://localhost:3000',      # Откуда дергаем данные
    CONF_CODE => 1,                            # период забора данных в часах
    CONF_LAST => nil,                          # Когда был последний опрос
    CONF_PROJECT_IDS => [],                    # Проекты которые являются коммерческими (массив identifier)
  }
end

Rails.application.config.to_prepare do
  Project.send(:include, CommercialProjects::ProjectPatch)
end
