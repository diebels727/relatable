# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{relatable}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonathan Quigg"]
  s.cert_chain = ["/home/jonathanquigg/.gemcert/gem-public_cert.pem"]
  s.date = %q{2011-03-20}
  s.description = %q{Emulate a triple store.}
  s.email = %q{diebels727@hotmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/relatable.rb"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "lib/relatable.rb", "relatable.gemspec"]
  s.homepage = %q{http://github.com/jquigg/relatable}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Relatable", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{relatable}
  s.rubygems_version = %q{1.6.2}
  s.signing_key = %q{/home/jonathanquigg/.gemcert/gem-private_key.pem}
  s.summary = %q{Emulate a triple store.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
