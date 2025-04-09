require "bridgetown"

Bridgetown.load_tasks

# Run rake without specifying any command to execute a deploy build by default.
task default: :deploy

#
# Standard set of tasks, which you can customize if you wish:
#
desc "Build the Bridgetown site for deployment"
task :deploy => [:clean, "frontend:build"] do
  Bridgetown::Commands::Build.start
end

desc "Build the site in a test environment"
task :test do
  ENV["BRIDGETOWN_ENV"] = "test"
  Bridgetown::Commands::Build.start
end

desc "Runs the clean command"
task :clean do
  Bridgetown::Commands::Clean.start
end

namespace :frontend do
  desc "Build the frontend with esbuild for deployment"
  task :build do
    sh "yarn run esbuild"
  end

  desc "Watch the frontend with esbuild during development"
  task :dev do
    sh "yarn run esbuild-dev"
  rescue Interrupt
  end
end

task :create_post do
  title = ENV["TITLE"]

  current_time = Time.now.strftime("%F")

  formatted_title = title.downcase.tr(" ", "-")

  extension = ".md"

  filename = current_time + "-" + formatted_title + extension

  base_url = "src/_posts/"

  path = base_url + filename

  File.open(path, "w+") do |file|
    file.puts "---"
    file.puts "layout: post"
    file.puts "title: #{title}"
    file.puts "categories: updates"
    file.puts "---"
  end

  puts "Successfully created #{title} at #{path} 🎉"
end

task :create_srn_post do
  posts = Dir.entries("src/_posts")
  last_srn_post = posts.select {|post| post.match? /newsletter/ }.sort.last
  last_srn_post_number = last_srn_post.match(/newsletter-(.+).md/).to_a.last

  title = "what-i-learned-from-short-ruby-newsletter-#{last_srn_post_number.to_i + 1}"
  post_title =  "what-i-learned-from-short-ruby-newsletter (##{last_srn_post_number.to_i + 1})"
  create_post_file(file_path(title), post_title)

  puts "Successfully created #{title} 🎉"
end

def file_path(title)
  current_time = Time.now.strftime("%F")

  formatted_title = title.downcase.tr(" ", "-")

  extension = ".md"

  filename = current_time + "-" + formatted_title + extension

  base_url = "src/_posts/"

  path = base_url + filename
end

def create_post_file(path, title)
  File.open(path, "w+") do |file|
    file.puts "---"
    file.puts "layout: post"
    file.puts "title: #{title}"
    file.puts "categories: updates"
    file.puts "---"
  end
end

#
# Add your own Rake tasks here! You can use `environment` as a prerequisite
# in order to write automations or other commands requiring a loaded site.
#
# task :my_task => :environment do
#   puts site.root_dir
#   automation do
#     say_status :rake, "I'm a Rake tast =) #{site.config.url}"
#   end
# end
