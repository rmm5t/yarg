# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{yarg}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan McGeary"]
  s.date = %q{2008-11-18}
  s.default_executable = %q{yarg}
  s.description = %q{Yet Another Ruby Generator: Customize existing project generators to fit your personality.}
  s.email = %q{}
  s.executables = ["yarg"]
  s.extra_rdoc_files = ["bin/yarg", "lib/yarg/file_actions.rb", "lib/yarg/rails.rb", "lib/yarg/scm/git.rb", "lib/yarg/scm.rb", "lib/yarg.rb", "README.markdown"]
  s.files = ["bin/yarg", "lib/yarg/file_actions.rb", "lib/yarg/rails.rb", "lib/yarg/scm/git.rb", "lib/yarg/scm.rb", "lib/yarg.rb", "Manifest", "Rakefile", "README.markdown", "test/file_actions_test.rb", "test/rails_test.rb", "test/scm_test.rb", "test/test_helper.rb", "yarg.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/rmm5t/yarg}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Yarg", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{yarg}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Yet Another Ruby Generator}
  s.test_files = ["test/file_actions_test.rb", "test/rails_test.rb", "test/scm_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
