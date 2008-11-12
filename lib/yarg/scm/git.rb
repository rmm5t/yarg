module Yarg
  module Scm
    class Git < Base
      def initialize(options = {})
        super
      end

      def init_commands
        ["git init"]
      end

      def commit_commands
        ["git add .", "git commit -m 'Initial commit. Yarg!'"]
      end

      def install_commands(repository, destination)
        ["git submodule add #{repository} #{destination}"]
      end
    end
  end
end
