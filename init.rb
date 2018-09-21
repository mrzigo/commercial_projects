CONF_ROLES = 'roles'
CONF_CRM_ATTR = 'crm_attr'
CONF_RM_ATTR = 'rm_attr'
CONF_MARKER = 'marker'
CONF_URL = 'url'
CONF_CODE = 'code'
CONF_LAST = 'last_download'

Redmine::Plugin.register :commercial_projects do
  name 'Commercial Projects'
  author 'DigitalWand (mr.zigo@yandex.ru)'
  description 'Отображение информации о коммерческих проектах'
  version '0.2'
  url 'https://github.com/mrzigo/commercial_projects'
  author_url 'https://github.com/mrzigo'

  settings partial: 'commercial_projects/settings', default: {
    CONF_ROLES => [1, 2],                      # Для каких ролей скрываем стытусы проектов (по умолчанию "не участник" и "Аноним" не видят)
    CONF_MARKER => '(₽)',                      # Каким символом помечаем комерческие проекты
    CONF_URL => 'https://localhost:3000',      # Откуда дергаем данные
    CONF_CODE => 1,                            # период забора данных в часах
    CONF_LAST => nil,                          # Когда был последний опрос
    CONF_CRM_ATTR => 'redmine_id',
    CONF_RM_ATTR => 'id',
  }

  ActionDispatch::Callbacks.to_prepare do
    require_dependency 'project'
    require_dependency 'principal'
    require_dependency 'user'
    require_dependency 'commercial_projects/project_patch'
    require_dependency 'commercial_projects/query_patch'
  end
end

Rails.application.config.to_prepare do
  Project.send(:include, CommercialProjects::ProjectPatch)
  Query.send(:include, CommercialProjects::QueryPatch)
end
