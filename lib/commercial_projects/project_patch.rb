require_dependency 'project'
require_dependency 'principal'
require_dependency 'user'

module CommercialProjects
  module ProjectPatch
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :name, :commercial_projects
      end
    end

    module ClassMethods
      def loading_commercial_projects
        settings = Setting[:plugin_commercial_projects]

        url = settings[:url].strip
        return if url.blank?

        begin
          uri = URI(url)
          response = Net::HTTP.get(uri)
        rescue
          raise "Ошибка получения данных с URL: ${url}"
        end

        raise("Пустые данные с URL: ${url}") if response.to_s.strip.blank?

        json = JSON.parse(response)
        code_status =  settings[:code].to_s.strip

        settings[:project_ids] = json.map do |id, attributes|
          if attributes['status'].to_s == code_status
            ::Project.find_by_id(id).try(:identifier)
          end
        end.compact

        settings[:last_download] = Time.new.strftime('%d-%m-%Y %H:%M')
        Setting[:plugin_commercial_projects] = settings
      end
    end

    module InstanceMethods
      def name
        self[:name]
      end

      def name_with_commercial_projects
        @roles_commercial_projects ||= (Setting.plugin_commercial_projects[:roles] || []).map(&:to_i) || []
        @projects_commercial_projects ||= Setting.plugin_commercial_projects[:project_ids] || []
        my_roles_on_project = memberships.where(user_id: User.current.id).includes(:roles).pluck('roles.id')
        return self[:name] if (my_roles_on_project & @roles_commercial_projects).count > 0
        @projects_commercial_projects.include?(identifier) ? "#{self[:name]} #{Setting.plugin_commercial_projects[:marker]}" : self[:name]
      end
    end
  end
end