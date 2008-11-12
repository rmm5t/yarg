module Yarg
  module Scm
    class Base
      attr_accessor :using

      def initialize(options = {})
        self.using = options[:using]
      end

      def init_commands
        []
      end

      def commit_commands
        []
      end

      def install(repository, destination)
        raise NotImplementedError, "install is not implemented by #{self.class.name}"
      end
    end

    def self.new(scm, options = {})
      scm_const = scm.to_s.capitalize.gsub(/_(.)/) { $1.upcase }
      load_scm(scm) unless const_defined?(scm_const)
      initialize_scm(scm_const, options)
    end

    private

    def self.load_scm(scm)
      scm_path = "yarg/scm/#{scm}"
      begin
        require(scm_path)
      rescue LoadError
        raise Yarg::Error, "could not find an SCM at #{scm_path}"
      end
    end

    def self.initialize_scm(scm_const, options)
      if const_defined?(scm_const)
        const_get(scm_const).new(options)
      else
        raise Yarg::Error, "could not find #{name}::#{scm_const}"
      end
    end
  end
end
