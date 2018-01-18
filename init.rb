Redmine::Plugin.register :commercial_projects do
  name 'Commercial Projects'
  author 'DigitalWand (mr.zigo@yandex.ru)'
  description 'Отображение информации о коммерческих проектах'
  version '0.1'
  url 'https://github.com/mrzigo/commercial_projects'
  author_url 'https://github.com/mrzigo'

  settings partial: 'commercial_projects/settings', default: {
    roles: [1, 2],                      # Для каких ролей скрываем стытусы проектов (по умолчанию "не участник" и "Аноним" не видят)
    marker: '(₽)',                      # Каким символом помечаем комерческие проекты
    url: 'https://localhost:3000',      # Откуда дергаем данные
    code: 1,                            # период забора данных в часах
    last_download: nil,                 # Когда был последний опрос
    project_ids: [],                    # Проекты которые являются коммерческими (массив identifier)
  }
end

Rails.application.config.to_prepare do
  Project.send(:include, CommercialProjects::ProjectPatch)
end
