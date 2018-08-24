# -*- encoding: utf-8 -*-
# stub: csvreader 0.4.0.20180824090426 ruby lib

Gem::Specification.new do |s|
  s.name = "csvreader".freeze
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Gerald Bauer".freeze]
  s.date = "2018-08-24"
  s.description = "csvreader - read tabular data in the comma-separated values (csv) format the right way (uses best practices out-of-the-box with zero-configuration)".freeze
  s.email = "wwwmake@googlegroups.com".freeze
  s.extra_rdoc_files = ["HISTORY.md".freeze, "LICENSE.md".freeze, "Manifest.txt".freeze, "README.md".freeze]
  s.files = ["HISTORY.md".freeze, "LICENSE.md".freeze, "Manifest.txt".freeze, "README.md".freeze, "Rakefile".freeze, "lib/csvreader.rb".freeze, "lib/csvreader/buffer.rb".freeze, "lib/csvreader/parser.rb".freeze, "lib/csvreader/reader.rb".freeze, "lib/csvreader/version.rb".freeze, "test/data/beer.csv".freeze, "test/data/beer11.csv".freeze, "test/data/shakespeare.csv".freeze, "test/helper.rb".freeze, "test/test_parser.rb".freeze, "test/test_reader.rb".freeze, "test/test_reader_hash.rb".freeze]
  s.homepage = "https://github.com/csv11/csvreader".freeze
  s.licenses = ["Public Domain".freeze]
  s.rdoc_options = ["--main".freeze, "README.md".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.2".freeze)
  s.rubygems_version = "2.7.3".freeze
  s.summary = "csvreader - read tabular data in the comma-separated values (csv) format the right way (uses best practices out-of-the-box with zero-configuration)".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>.freeze, ["< 6", ">= 4.0"])
      s.add_development_dependency(%q<hoe>.freeze, ["~> 3.17"])
    else
      s.add_dependency(%q<rdoc>.freeze, ["< 6", ">= 4.0"])
      s.add_dependency(%q<hoe>.freeze, ["~> 3.17"])
    end
  else
    s.add_dependency(%q<rdoc>.freeze, ["< 6", ">= 4.0"])
    s.add_dependency(%q<hoe>.freeze, ["~> 3.17"])
  end
end
