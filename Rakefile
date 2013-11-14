# Copyright 2013 Travis CI team and contributors
require 'erb'

desc "Generate blog post file in blog/_posts"
task :gen_blog_post, [:title] do |t, args|
  template = File.read(File.join(File.dirname(__FILE__),'templates', 'blog.erb'))

  title            = args.title
  title_normalized = title.downcase.split.join('-').gsub(/[^a-z]-/,'')
  time             = Time.now
  date_stamp       = time.strftime('%Y-%m-%d')
  permalink        = "#{date_stamp}-#{title_normalized}"
  file_name        = "#{permalink}.md"

  erb = ERB.new(template)

  File.open(File.join('blog/_posts', file_name), 'w+') do |f|
    f.write erb.result(binding)
    puts "blog/_posts/#{file_name} generated"
  end

  if editor = ENV['VISUAL'] || ENV['EDITOR']
    system "#{editor} blog/_posts/#{file_name}"
  end
end