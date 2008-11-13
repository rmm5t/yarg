require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'mocha'
begin require 'redgreen' if ENV['TM_FILENAME'].nil?; rescue LoadError; end
require 'yarg'

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
      should "have attribute of #{attribute.inspect} matching #{expected.inspect}" do
        assert_operator expected, :===, @generator.send(attribute)
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

  def stub_fake_system_calls(project_name)
    ENV["PROJECT_NAME"] = project_name
    @generator.stubs(:sh)
    Dir.stubs(:mkdir)
    Dir.stubs(:chdir)
    Dir.stubs(:glob)
    Dir.stubs(:glob).with("public/index.html").returns(%w(public/index.html))
    Dir.stubs(:glob).with("public/dispatch.*").returns(%w(public/dispatch.cgi public/dispatch.fcgi public/dispatch.rb))
    Dir.stubs(:glob).with("/tmp/.yarg.d/rails/*").returns(["/tmp/.yarg.d/rails"])
    File.stubs(:delete)
    FileUtils.stubs(:cp_r)
  end
end
