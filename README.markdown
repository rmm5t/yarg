# yarg: Yet Another Ruby Generator

Yarg is Yet Another Ruby Generator.  It allows you to customize existing project
generators to fit your personality or common scaffolding.

**Yarg is still in its infancy.  It currently works for rails generation, but use it at your own risk.**

## Usage

Install:

    gem install rmm5t-yarg --source http://gems.github.com

Configure by placing a <tt>~/.yarg</tt> file in your home directory.  Here's a simple example

    Yarg::Rails.new do |rg|
      rg.scm :git
      rg.delete "public/index.html"
      rg.delete "public/dispatch.*"
      rg.plugin "git://github.com/thoughtbot/shoulda.git"
      rg.plugin "git://github.com/nex3/haml.git"
      rg.freeze
    end

Here's another example:

    Yarg::Rails.new do |rg|
      rg.scm :git, :using => :submodules
      rg.delete "public/index.html"
      rg.delete "public/dispatch.*"
      rg.plugin "git://github.com/thoughtbot/shoulda.git"
      rg.plugin "git://github.com/nex3/haml.git"
      rg.plugin "git://github.com/rmm5t/strip_attributes.git"
      rg.plugin "git://github.com/github/hubahuba.git"
      rg.freeze :version => :edge
    end

Afterwards, you should be able to launch a new Rails project easily:

    yarg my_new_project

## TODO

* Add better option parsing support in script
* Add template directory support
* Add rails gem freezing support
* Add newgem support
* Add merb support
* Add webby support
* Add staticmatic support
* Add svn support (?)

## Other

[MIT License](http://www.opensource.org/licenses/mit-license.php)

Copyright (c) 2008, Ryan McGeary (ryanonruby -[at]- mcgeary [*dot*] org)
