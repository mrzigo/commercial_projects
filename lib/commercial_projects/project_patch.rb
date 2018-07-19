module CommercialProjects
  module ProjectPatch
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :name, :commercial_projects
        before_save :save_name_without_suffix
      end
    end

    module ClassMethods
      def loading_commercial_projects
        settings = Setting[:plugin_commercial_projects]

        url = settings[CONF_URL].strip
        return if url.blank?

        begin
          uri = URI(url)
          response = Net::HTTP.get(uri)
        rescue
          raise "Ошибка получения данных с URL: ${url}"
        end

        raise("Пустые данные с URL: ${url}") if response.to_s.strip.blank?

        json = JSON.parse(response)
        code_status =  settings[CONF_CODE].to_s.strip

        settings[CONF_PROJECT_IDS] = json.map do |project|
          if project['type'].to_s != code_status
            ::Project.where(settings[CONF_RM_ATTR] => project[settings[CONF_CRM_ATTR]]).first.try(:identifier)
            # ::Project.find_by_id(project[settings[CONF_CRM_ATTR]]).try(:identifier)
          end
        end.compact.uniq

        settings[CONF_LAST] = Time.new.strftime('%d-%m-%Y %H:%M')
        Setting[:plugin_commercial_projects] = settings
      end
    end

    module InstanceMethods
      def name
        self[:name]
      end

      def name_with_commercial_projects
        @roles_commercial_projects ||= (Setting.plugin_commercial_projects[CONF_ROLES] || []).map(&:to_i) || []
        @projects_commercial_projects ||= Setting.plugin_commercial_projects[CONF_PROJECT_IDS] || []
        my_roles_on_project = memberships.where(user_id: User.current.id).includes(CONF_ROLES).pluck('roles.id')
        return self[:name] if (my_roles_on_project & @roles_commercial_projects).count > 0
        @projects_commercial_projects.include?(identifier) ? "#{self[:name]} #{Setting.plugin_commercial_projects[CONF_MARKER]}" : self[:name]
      end

      def save_name_without_suffix
        self[:name].gsub!(Setting.plugin_commercial_projects[CONF_MARKER],'')
        self[:name].strip!
      end
    end
  end
end
