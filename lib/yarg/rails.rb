require 'yarg'
require 'yarg/file_actions'
require 'rake/tasklib'

module Yarg
  # Create a task that customizes a Rails project generation bootstrap.
  #
  # Example (<tt>~/.yarg</tt>):
  #
  #   Yarg::Rails.new do |rg|
  #     rg.template "~/.yarg.d/default"
  #     rg.delete "public/index.html"
  #     rg.delete "public/dispatch.*"
  #     rg.plugin "git://github.com/thoughtbot/shoulda.git"
  #     rg.plugin "git://github.com/nex3/haml.git"
  #     rg.freeze :version => :edge
  #   end
  class Rails < Rake::TaskLib
    include Yarg::FileActions

    # Name of rails generator task. (default is :rails)
    attr_accessor :name

    # List of plugins to install. (default is NONE)
    attr_accessor :plugins

    # True if freezing rails under vendor/rails is desired. (default is false)
    attr_accessor :frozen

    # Version to freeze rails if frozen is true. (default is :gems)
    attr_accessor :freeze_version

    def initialize(name = :rails)
      self.name = name
      self.plugins = []
      self.frozen = false
      initialize_file_actions
      yield self if block_given?
      define
    end

    def plugin(repository)
      self.plugins << repository
    end

    def freeze(options = {})
      self.frozen = true
      self.freeze_version = options[:version] || :gems
    end

    private

    def define
      task self.name do
        app_name = ENV["PROJECT_NAME"]
        sh("rails #{app_name}")
        Dir.chdir(app_name)
        apply_file_actions
        apply_plugins
        apply_freeze
        apply_scm_commit
      end
      self
    end

    def apply_plugins
      plugins.each do |plugin|
        if scm_module && scm_module.using
          plugin_name = File.basename(plugin, ".*")
          exec_commands(scm_module.install_commands(plugin, "vendor/plugins/#{plugin_name}"))
        else
          sh("./script/plugin install #{plugin}")
        end
      end
    end

    def apply_freeze
      return unless frozen
      if scm_module && scm_module.using
        exec_commands(scm_module.install_commands("git://github.com/rails/rails.git", "vendor/rails"))
      elsif [:gems, :edge].include?(freeze_version.to_sym)
        sh("rake rails:freeze:#{freeze_version}")
      end
    end
  end
end
