namespace :redmine do
  namespace :plugins do
    namespace :commercial_projects do

      desc 'Загрузка данных из CRM'
      task :download => :environment do
        ::Project.loading_commercial_projects
      end
    end
  end
end
