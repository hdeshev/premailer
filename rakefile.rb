require 'rake'
require 'fileutils'
require 'lib/premailer'
require 'rake/rdoctask'
require 'rake/gempackagetask'

desc 'Default: parse a URL.'
task :default => [:inline]

desc 'Parse a URL and write out the output.'
task :inline do
  url = ENV['url']
  output = ENV['output']
  
  if !url or url.empty? or !output or output.empty?
    puts 'Usage: rake inline url=http://example.com/ output=output.html'
    exit
  end

  premailer = Premailer.new(url, :warn_level => Premailer::Warnings::SAFE)
  fout = File.open(output, "w")
  fout.puts premailer.to_inline_css
  fout.close

  puts "Succesfully parsed '#{url}' into '#{output}'"
  puts premailer.warnings.length.to_s + ' CSS warnings were found'
end

task :text do
  url = ENV['url']
  output = ENV['output']
  
  if !url or url.empty? or !output or output.empty?
    puts 'Usage: rake text url=http://example.com/ output=output.txt'
    exit
  end

  premailer = Premailer.new(url, :warn_level => Premailer::Warnings::SAFE)
  fout = File.open(output, "w")
  fout.puts premailer.to_plain_text
  fout.close
  
  puts "Succesfully parsed '#{url}' into '#{output}'"
end

desc 'Generate documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Premailer'
  rdoc.options << '--all' << '--inline-source' << '--line-numbers'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('CHANGELOG')
  rdoc.rdoc_files.include('LICENSE')
  rdoc.rdoc_files.include('lib/*.rb')
  rdoc.rdoc_files.include('lib/premailer/*.rb')
end


desc 'Generate fancy documentation.'
Rake::RDocTask.new(:fancy) do |rdoc|
  rdoc.rdoc_dir = 'fdoc'
  rdoc.title    = 'Premailer'
  rdoc.options << '--all' << '--inline-source' << '--line-numbers'
  rdoc.rdoc_files.include('lib/*.rb')
  rdoc.rdoc_files.include('lib/premailer/*.rb')
  rdoc.template = File.expand_path(File.dirname(__FILE__) + '/doc-template.rb')
end



spec = Gem::Specification.new do |s| 
  s.name = 'premailer'
  s.version = '1.5.5.1'
  s.author = 'Alex Dunae '
  s.homepage = 'http://github.com/alexdunae/premailer/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A set of classes for generating email-friendly HTML. A quick and dirty release off the latest master branch on GitHub done by Hristo Deshev.'
  s.files = FileList['lib/*.rb', 'lib/**/*.rb', 'bin/**/*', 'misc/**/*', 'test/**/*'].to_a
  s.test_files = Dir.glob('test/test_*.rb') 
  s.has_rdoc = true
  s.rdoc_options << '--all' << '--inline-source' << '--line-numbers'
end

desc 'Build the premailer gem.'
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_zip = true
  pkg.need_tar = true 
end 

