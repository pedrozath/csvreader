require 'hoe'
require './lib/csvreader/version.rb'

Hoe.plugin :gemspec
Hoe.spec 'csvreader' do

  self.version = CsvReader::VERSION

  self.summary = "csvreader - read tabular data in the comma-separated values (csv) format the right way (uses best practices out-of-the-box with zero-configuration)"
  self.description = summary

  self.urls = ['https://github.com/csv11/csvreader']

  self.author = 'Gerald Bauer'
  self.email = 'wwwmake@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file = 'README.md'
  self.history_file = 'HISTORY.md'

  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 2.2.2'
  }

end
