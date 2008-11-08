require 'test_helper'
require 'yarg/rails'

class RailsTest < Test::Unit::TestCase
  def self.should_have_rg_attribute_of(attribute, expected)
    should "have attribute of #{attribute.inspect} equal to #{expected.inspect}" do
      assert_equal expected, @rg.send(attribute)
    end
  end

  def self.should_run_rails_command_for_app(app_name)
    before_should "execute rails system call for #{app_name}" do
      @rg.expects(:sh).with("rails --quiet #{app_name}")
    end
  end

  def setup
    Rake::Task.clear
  end

  context "A missing Rails generator" do
    should_not_define_task :rails
  end

  context "An empty default Rails generator" do
    setup do
      @rg = Yarg::Rails.new do |rg| end
      stub_rails_system_calls("my_app")
    end

    should_define_task :rails
    should_have_rg_attribute_of :name,      :rails
    should_have_rg_attribute_of :deletions, []
    should_have_rg_attribute_of :plugins,   []
    should_have_rg_attribute_of :templates, []
    should_have_rg_attribute_of :frozen,    false
    should_have_rg_attribute_of :freeze_version, nil

    context "once invoked" do
      setup do
        Rake::Task[:rails].invoke
      end

      should_run_rails_command_for_app "my_app"
      should_cd_into "my_app"

      before_should "not delete any files" do
        File.expects(:delete).never
      end
    end
  end

  context "A Rails generator with multiple options set" do
    setup do
      @rg = Yarg::Rails.new(:template) do |rg|
        rg.delete "public/index.html"
        rg.delete "public/dispatch.*"
        rg.plugin "git://github.com/thoughtbot/shoulda.git"
        rg.template "~/.yarg.d/rails"
        rg.freeze :version => :edge
      end
      stub_rails_system_calls("my_rails_project")
    end

    should_define_task :template
    should_have_rg_attribute_of :name,      :template
    should_have_rg_attribute_of :deletions, %w(public/index.html public/dispatch.*)
    should_have_rg_attribute_of :plugins,   %w(git://github.com/thoughtbot/shoulda.git)
    should_have_rg_attribute_of :templates, %w(~/.yarg.d/rails)
    should_have_rg_attribute_of :frozen,    true
    should_have_rg_attribute_of :freeze_version, :edge

    context "once invoked" do
      setup do
        Rake::Task[:template].invoke
      end

      should_run_rails_command_for_app "my_rails_project"
      should_cd_into "my_rails_project"

      before_should "delete some unused files" do
        File.expects(:delete).with("public/index.html")
        File.expects(:delete).with("public/dispatch.cgi", "public/dispatch.fcgi", "public/dispatch.rb")
      end
    end
  end

  context "A Rails generator with a default freeze" do
    setup do
      @rg = Yarg::Rails.new do |rg|
        rg.freeze
      end
    end

    should_have_rg_attribute_of :frozen, true
    should_have_rg_attribute_of :freeze_version, :gems
  end

  private

  def stub_rails_system_calls(app_name)
    ENV["APP_NAME"] = app_name
    @rg.stubs(:sh)
    Dir.stubs(:chdir)
    Dir.stubs(:glob)
    Dir.stubs(:glob).with("public/index.html").returns(%w(public/index.html))
    Dir.stubs(:glob).with("public/dispatch.*").returns(%w(public/dispatch.cgi public/dispatch.fcgi public/dispatch.rb))
    File.stubs(:delete)
  end
end
