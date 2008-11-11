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

    def should_have_generator_attribute_of(attribute, expected)
      should "have attribute of #{attribute.inspect} equal to #{expected.inspect}" do
        assert_equal expected, @generator.send(attribute)
      end
    end

    def should_run_rails_command_for_app(app_name)
      before_should "execute rails system call for #{app_name}" do
        @generator.expects(:sh).with("rails #{app_name}")
      end
    end

    def should_delete(*files)
      before_should "delete #{files.inspect}" do
        File.expects(:delete).with(*files)
      end
    end

    def should_not_delete_any_files
      before_should "not delete any files" do
        File.expects(:delete).never
      end
    end

    def should_invoke(matching_command)
      before_should "invoke #{matching_command.inspect}" do
        @generator.expects(:sh).with { |value|
          matching_command === value
        }
      end
    end

    def should_not_invoke(matching_command)
      before_should "not invoke #{matching_command.inspect}" do
        @generator.expects(:sh).with { |value|
          matching_command === value
        }.never
      end
    end
  end
end

class Test::Unit::TestCase
  extend ShouldaHelper::Macros
end
