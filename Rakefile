#!/usr/bin/env rake

require File.expand_path('./lib/uboost-client/version')

desc "Build gem"
task 'build' do
  system("gem build uboost-client.gemspec")
end

desc "Publish gem"
task "release" do
  system("gem push uboost-client-#{UboostClient::VERSION}.gem")
end

desc "Remove built gems"
task "clear" do
  system("rm *.gem")
end