# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{yarg}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan McGeary"]
  s.date = %q{2008-11-13}
  s.default_executable = %q{yarg}
  s.executables = ["yarg"]
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["Rakefile", "README.markdown", "bin/yarg", "lib/yarg", "lib/yarg/file_actions.rb", "lib/yarg/rails.rb", "lib/yarg/scm", "lib/yarg/scm/git.rb", "lib/yarg/scm.rb", "lib/yarg.rb", "test/file_actions_test.rb", "test/rails_test.rb", "test/scm_test.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/rmm5t/yarg}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Yet Another Ruby Generator}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
