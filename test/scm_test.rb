require 'test_helper'
require 'yarg/scm'
require 'yarg/scm/git'

class Yarg::Scm::Custom < Yarg::Scm::Base
  def initialize(options = {})
  end
end

class ScmTest < Test::Unit::TestCase
  def setup
    Rake::Task.clear
  end

  context "Creating a new git SCM" do
    setup do
      @scm = Yarg::Scm.new(:git)
    end

    should_change "@scm", :to => Yarg::Scm::Git

    should "return git init commands" do
      assert_equal ["git init"], @scm.init_commands
    end

    should "return git commit commands" do
      assert_equal ["git add .", "git commit -m 'Initial commit. Yarg!'"], @scm.commit_commands
    end

    should "return git install commands" do
      assert_equal ["git submodule add git://example.com/foo.git vendor/plugins/foo"], @scm.install_commands("git://example.com/foo.git", "vendor/plugins/foo")
    end
  end

  context "Creating a new custom SCM" do
    setup do
      @scm = Yarg::Scm.new(:custom)
    end

    should_change "@scm", :to => Yarg::Scm::Custom

    should "return empty init commands" do
      assert @scm.init_commands.empty?
    end

    should "return empty commit commands" do
      assert @scm.commit_commands.empty?
    end

    should "raise error on install request" do
      assert_raise NotImplementedError do
        @scm.install(:a, :b)
      end
    end
  end

  context "Creating a new unknown SCM" do
    should "fail" do
      assert_raise Yarg::Error do
        @scm = Yarg::Scm.new(:unknown)
      end
    end
  end
end
