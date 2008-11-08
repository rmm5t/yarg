require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'mocha'
begin require 'redgreen' if ENV['TM_FILENAME'].nil?; rescue LoadError; end

module ShouldaHelper
  module Macros
    def should_define_task(task)
      should "define the task #{task.inspect}" do
        assert Rake::Task.task_defined?(task)
      end
    end

    def should_not_define_task(task)
      should "not define the task #{task.inspect}" do
        assert !Rake::Task.task_defined?(task)
      end
    end

    def should_cd_into(directory)
      before_should "chdir into #{directory}" do
        Dir.expects(:chdir).with(directory)
      end
    end
  end
end

class Test::Unit::TestCase
  extend ShouldaHelper::Macros
end
