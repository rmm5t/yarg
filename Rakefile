require 'rake'
require 'rake/testtask'
require 'lib/yarg'

begin
  require 'echoe'

  Echoe.new('yarg', Yarg::VERSION) do |p|
    # p.rubyforge_name = 'yarg'
    p.summary      = "Yet Another Ruby Generator"
    p.description  = "Yet Another Ruby Generator: Customize existing project generators to fit your personality."
    p.url          = "http://github.com/rmm5t/yarg"
    p.author       = ["Ryan McGeary"]
  end

rescue LoadError => boom
  puts "You are missing a dependency required for meta-operations on this gem."
  puts "#{boom.to_s.capitalize}."
end
