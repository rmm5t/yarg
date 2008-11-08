module Yarg
  module FileActions
    # List of paths to delete. (default is NONE)
    attr_accessor :deletions

    # List of source template paths to overwrite files in the destination
    # project. (default is NONE)
    attr_accessor :templates

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

    private

    def apply_file_actions
      apply_deletions
      apply_templates
    end

    def apply_deletions
      self.deletions.each do |path|
        File.delete(*Dir.glob(path))
      end
    end

    def apply_templates
      # TODO
    end
  end
end
