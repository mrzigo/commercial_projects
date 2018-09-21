# module MethodRemote
#   def remote
#     puts '!!!!?????'
#     true
#   end
# end

module CommercialProjects
  module QueryPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable
        alias_method_chain :available_filters, :commercial_projects
      end
    end

    module InstanceMethods
      def sql_for_project_commercial_field(field, operator, v)
        sql_for_field(field, operator, v, Project.table_name, 'commercial')
      end

      def available_filters_with_commercial_projects
        @available_filters = available_filters_without_commercial_projects
        #
        @roles_commercial_projects ||= (Setting.plugin_commercial_projects[CONF_ROLES] || []).map(&:to_i) || []
        my_roles = User.current.roles.map(&:id)
        return @available_filters if (my_roles & @roles_commercial_projects).count > 0

        filters = QueryFilter.new(
          'project.commercial',
          {
            :name => 'Коммерческий',
            :type => :list,
            :values => [['Да', 1], ['Нет', 0]],
          }
        )
        return @available_filters.merge!({"project.commercial" => filters})
      end

    end
  end
end
