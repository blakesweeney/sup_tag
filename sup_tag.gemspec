# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sup_tag}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Blake Sweeney"]
  s.date = %q{2010-10-19}
  s.description = %q{SupTag lets you clean up the before-add-hook script by providing a clean DSL}
  s.email = %q{blakes.85@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "lib/sup_tag.rb",
     "lib/sup_tag/extensions/Object.rb",
     "spec/dummy_source.rb",
     "spec/object_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/sup_tag_spec.rb",
     "sup_tag.gemspec"
  ]
  s.homepage = %q{http://github.com/blakesweeney/sup_tag}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Make tagging messages in sup pretty}
  s.test_files = [
    "spec/dummy_source.rb",
     "spec/object_spec.rb",
     "spec/spec_helper.rb",
     "spec/sup_tag_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<sup>, [">= 0.11"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<sup>, [">= 0.11"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<sup>, [">= 0.11"])
  end
end

