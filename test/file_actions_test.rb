require 'test_helper'
require 'yarg/file_actions'
require 'yarg/scm/git'

class FakeGen < Rake::TaskLib
  include Yarg::FileActions

  def initialize(name = :fake)
    @name = name
    initialize_file_actions
    yield self if block_given?
    define
  end

  private

  def define
    task @name do
      project_name = ENV["PROJECT_NAME"]
      Dir.mkdir(project_name)
      Dir.chdir(project_name)
      apply_file_actions
      apply_scm_commit
    end
    self
  end
end

class FileActionsTest < Test::Unit::TestCase
  def setup
    Rake::Task.clear
  end

  context "An empty Fake generator" do
    setup do
      @generator = FakeGen.new do |rg| end
      stub_fake_system_calls("my_app")
    end

    should_define_task :fake
    should_have_generator_attribute_of :scm_module, nil

    context "once invoked" do
      setup do
        Rake::Task[:fake].invoke
      end

      should_cd_into "my_app"
      should_not_delete_any_files
      should_not_invoke %r{^git}
      should_not_invoke %r{^svn}
    end
  end

  context "An Fake generator using GIT" do
    setup do
      @generator = FakeGen.new do |rg|
        rg.scm :git
      end
      stub_fake_system_calls("my_app")
    end

    should_define_task :fake
    should_have_generator_attribute_of :scm_module, Yarg::Scm::Git

    context "once invoked" do
      setup do
        Rake::Task[:fake].invoke
      end

      should_cd_into "my_app"
      should_not_delete_any_files
      should_invoke %r{^git init}
      should_invoke %r{^git add}
      should_invoke %r{^git commit}
    end
  end

  context "A Fake generator with a template" do
    setup do
      @generator = FakeGen.new do |rg|
        rg.template "/tmp/.yarg.d/rails"
      end
      stub_fake_system_calls("my_app")
    end

    should_have_generator_attribute_of :templates,  %w(/tmp/.yarg.d/rails)

    context "once invoked" do
      setup do
        Rake::Task[:fake].invoke
      end

      should_cd_into "my_app"
      should_not_delete_any_files

      before_should "copy template files from" do
        FileUtils.expects(:cp_r).with(["/tmp/.yarg.d/rails"], ".", :verbose => true)
      end
    end
  end
end
