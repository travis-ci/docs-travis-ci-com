require "html/proofer"
task :default => :test

task :test do
  sh "bundle exec jekyll build"
  HTML::Proofer.new("./_site/", {
    :href_ignore => [
      "#",
      "#Android",
      "#Application-or-Environment-to-deploy",
      "#Application-to-deploy",
      "#Arbitrary-directories",
      "#Build-Monitoring",
      "#Cassandra",
      "#CouchDB",
      "#Dashboards",
      "#Deploy-Strategy",
      "#Editors",
      "#ElasticSearch",
      "#Fetching-and-storing-caches",
      "#Full-Clients",
      "#Full-Web-Clients",
      "#Gem-to-release",
      "#Generators",
      "#Google-Chrome",
      "#iOS",
      "#JavaScript",
      "#Kestrel",
      "#Linux",
      "#Mac-OS-X",
      "#Memcached",
      "#MongoDB",
      "#Mozilla-Firefox",
      "#MySQL",
      "#Neo4J",
      "#Opera",
      "#Other",
      "#PHP",
      "#PostgreSQL",
      "#RabbitMQ",
      "#Redis",
      "#Riak",
      "#Ruby",
      "#SQLite3",
      "#Starting-a-Web-Server",
      "#Tools",
      "#Windows",
      "#Windows-Phone",
      "/user/addons/#Sauce-Connect",
      "/user/build-configuration/#Define-custom-build-lifecycle-commands",
      "/user/build-configuration/#Secure-environment-variables",
      "/user/build-configuration/#The-Build-Matrix",
      "/user/ci-environment/#Environment-variables",
      "/user/database-setup/#multiple-database-systems",
      "/user/deployment/#Other-Providers",
      "/user/languages/java/#Overview",
      "/user/languages/java/#Testing-Against-Multiple-JDKs",
      "/user/languages/ruby/#Custom-Bundler-arguments-and-Gemfile-locations",
      "/user/languages/scala#Projects-using-sbt",
      "/user/pull-requests#Security-Restrictions-when-testing-Pull-Requests",
      "/user/travis-pro/#How-can-I-configure-Travis-Pro-to-use-private-GitHub-repositories-as-dependencies%3F",
      "/user/travis-pro/#How-can-I-encrypt-files-that-include-sensitive-data%3F",
      "/user/using-postgresql/#Using-PostGIS",
      "irc://chat.freenode.net/%23travis"
    ],
    :disable_external => true
    }).run
end
