require 'yarg/scm'

module Yarg
  module FileActions
    # List of paths to delete. (default is NONE)
    attr_accessor :deletions

    # List of source template paths to overwrite files in the destination
    # project. (default is NONE)
    attr_accessor :templates

    # Source control management module to use (default is NONE)
    attr_accessor :scm_module

    def initialize_file_actions
      self.deletions = []
      self.templates = []
    end

    def delete(relative_path)
      self.deletions << relative_path
    end

    def template(absolute_path)
      self.templates << absolute_path
    end

    def scm(scm, options = {})
      self.scm_module = Scm.new(scm, options)
    end

    private

    def apply_file_actions
      apply_deletions
      apply_templates
      apply_scm_init
    end

    def apply_deletions
      self.deletions.each do |path|
        File.delete(*Dir.glob(path))
      end
    end

    def apply_templates
      self.templates.each do |path|
        everything_including_dotfiles = "{.[!.]*,*}"
        sources = Dir.glob(File.join(File.expand_path(path), everything_including_dotfiles))
        FileUtils.cp_r(sources, ".", :verbose => true)
      end
    end

    def apply_scm_init
      exec_commands(self.scm_module.init_commands) if self.scm_module
    end

    def apply_scm_commit
      exec_commands(self.scm_module.commit_commands) if self.scm_module
    end

    def exec_commands(commands)
      commands.each do |command|
        sh(command)
      end
    end
  end
end
