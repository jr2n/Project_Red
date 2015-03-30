# encoding: UTF-8

require 'redmine'

Redmine::Plugin.register :ppr do
    name 'Issue Importer'
    author 'Martin Liu / Leo Hourvitz / Stoyan Zhekov / Jérôme Bataille'
    description 'Issue import plugin for Redmine.'
    version '1.2.2'

    project_module :importer do
        permission :import, :importer => :index
    end

    menu :project_menu, :importer, { :controller => 'importer', :action => 'index' }, :caption => :label_import, :before => :settings, :param => :project_id
    menu :application_menu, :resources, { :controller=> 'resources', :action=> 'show' }, :caption=> 'Resources', :if=> Proc.new { User.current.logged? && User.current.admin? }
end

require_dependency 'ppr/hooks/user_schedule_entries_hook'
require_dependency 'ppr/hooks/user_exception_entries_hook'
require_dependency 'ppr/events/resourcescheduleevent.rb'
