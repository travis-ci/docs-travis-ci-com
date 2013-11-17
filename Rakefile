# Copyright 2013 Travis CI team and contributors
require 'erb'

desc "Generate blog post file in blog/_posts"
task :gen_blog_post, [:title] do |t, args|
  template = File.read(File.join(File.dirname(__FILE__),'templates', 'blog.erb'))

  title            = args.title
  title_normalized = title.downcase.split.join('-').gsub(/[^a-z-]/,'')
  time             = Time.now
  date_stamp       = time.strftime('%Y-%m-%d')
  permalink        = "#{date_stamp}-#{title_normalized}"
  file_name        = "#{permalink}.md"
  file_full_path   = File.join('blog', '_posts', file_name)
  erb              = ERB.new(template)

  File.open(file_full_path, 'w+') do |f|
    f.write erb.result(binding)
    puts "#{file_full_path} generated"
  end

  if editor = ENV['VISUAL'] || ENV['EDITOR']
    system "#{editor} #{file_full_path}"
  end
end
