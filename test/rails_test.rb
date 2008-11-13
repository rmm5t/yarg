require 'test_helper'
require 'yarg/rails'

class RailsTest < Test::Unit::TestCase
  def setup
    Rake::Task.clear
  end

  context "A missing Rails generator" do
    should_not_define_task :rails
  end

  context "An empty default Rails generator" do
    setup do
      @generator = Yarg::Rails.new do |rg| end
      stub_fake_system_calls("my_app")
    end

    should_define_task :rails
    should_have_generator_attribute_of :name,      :rails
    should_have_generator_attribute_of :deletions, []
    should_have_generator_attribute_of :plugins,   []
    should_have_generator_attribute_of :templates, []
    should_have_generator_attribute_of :frozen,    false
    should_have_generator_attribute_of :freeze_version, nil

    context "once invoked" do
      setup do
        Rake::Task[:rails].invoke
      end

      should_run_rails_command_for_app "my_app"
      should_cd_into "my_app"
      should_not_delete_any_files
      should_not_invoke %r{^\./script/plugin install}
      should_not_invoke %r{^rake rails:freeze}
      should_eventually "not overwrite with any templates"
    end
  end

  context "A Rails generator with multiple options set" do
    setup do
      @generator = Yarg::Rails.new(:template) do |rg|
        rg.scm :git, :using => :submodules
        rg.delete "public/index.html"
        rg.delete "public/dispatch.*"
        rg.plugin "git://github.com/thoughtbot/shoulda.git"
        rg.plugin "git://github.com/nex3/haml.git"
        rg.template "/tmp/.yarg.d/rails"
        rg.freeze :version => :edge
      end
      stub_fake_system_calls("my_rails_project")
    end

    should_define_task :template
    should_have_generator_attribute_of :name,       :template
    should_have_generator_attribute_of :scm_module, Yarg::Scm::Git
    should_have_generator_attribute_of :deletions,  %w(public/index.html public/dispatch.*)
    should_have_generator_attribute_of :plugins,    %w(git://github.com/thoughtbot/shoulda.git git://github.com/nex3/haml.git)
    should_have_generator_attribute_of :templates,  %w(/tmp/.yarg.d/rails)
    should_have_generator_attribute_of :frozen,     true
    should_have_generator_attribute_of :freeze_version, :edge

    context "once invoked" do
      setup do
        Rake::Task[:template].invoke
      end

      should_run_rails_command_for_app "my_rails_project"
      should_cd_into "my_rails_project"
      should_delete "public/index.html"
      should_delete "public/dispatch.cgi", "public/dispatch.fcgi", "public/dispatch.rb"
      should_invoke "git submodule add git://github.com/thoughtbot/shoulda.git vendor/plugins/shoulda"
      should_invoke "git submodule add git://github.com/nex3/haml.git vendor/plugins/haml"
      should_invoke "git submodule add git://github.com/rails/rails.git vendor/rails"
      should_invoke %r{^git init}
      should_invoke %r{^git add}
      should_invoke %r{^git commit}
      should_eventually "overwrite with the template"
    end
  end

  context "A Rails generator with a default freeze" do
    setup do
      @generator = Yarg::Rails.new do |rg|
        rg.freeze
      end
      stub_fake_system_calls("my_app")
    end

    should_have_generator_attribute_of :frozen, true
    should_have_generator_attribute_of :freeze_version, :gems

    context "once invoked" do
      setup do
        Rake::Task[:rails].invoke
      end

      should_run_rails_command_for_app "my_app"
      should_cd_into "my_app"
      should_not_invoke %r{^\./script/plugin install}
      should_invoke "rake rails:freeze:gems"
      should_eventually "not overwrite with any templates"
    end
  end

  context "A Rails generator with a default scm" do
    setup do
      @generator = Yarg::Rails.new do |rg|
        rg.scm :git
        rg.plugin "git://github.com/nex3/haml.git"
        rg.freeze :version => :edge
      end
      stub_fake_system_calls("my_app")
    end

    should_have_generator_attribute_of :scm_module, Yarg::Scm::Git

    context "once invoked" do
      setup do
        Rake::Task[:rails].invoke
      end

      should_invoke "./script/plugin install git://github.com/nex3/haml.git"
      should_invoke "rake rails:freeze:edge"
      should_invoke %r{^git init}
      should_invoke %r{^git add}
      should_invoke %r{^git commit}
    end
  end
end
