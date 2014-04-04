require 'yaml'
require 'rdf'
require 'rdf/raptor'
require 'sparql'

# Hack!  Raptor needed and ruby doesn't find the lib after a homebrew install
ENV['DYLD_LIBRARY_PATH'] = '/opt/boxen/homebrew/Cellar/raptor/2.0.13/lib'

namespace :doap do
  desc 'Builds the _data/sdks.yml file by fetching Description of A Project for each SDK from the semantic web'
  task :build_sdk_yml do
    converter = DOAPConverter.new
    # PyPI also has DOAP, but it isn't very good (at least it wasn't for Pyrax)
    # PyPI url: https://pypi.python.org/pypi?:action=doap&name=pyrax
    converter.load "http://rdfohloh.wikier.org/project/pyrax.rdf"
    converter.load "http://rdfohloh.wikier.org/project/jclouds.rdf"
    # converter.load "http://svn.apache.org/repos/asf/libcloud/trunk/doap_libcloud.rdf"
    converter.save_simple_yaml 'site_source/_data/sdks.yml'
  end
end

class DOAPConverter
  def initialize
    @sdk_repo = RDF::Repository.new
  end

  def load(rdf_url)
    @sdk_repo.load rdf_url
  end

  def to_simple_yaml
    sdks = {}
    optional_keys = %w{
      homepage programming-language description shortdesc download-page
      license bug-database mailing-list
    }
    # removed keys that I have trouble parsing:
    # repository, maintainer and category (which can cause duplicate results)
    optional_selectors = optional_keys.map{ |key|
      "OPTIONAL { ?project doap:#{key} ?#{key.gsub('-','_')} }"
    }.join("\n")
    query = SPARQL.parse %(
      PREFIX doap: <http://usefulinc.com/ns/doap#>
      select distinct *
      WHERE {
        ?project a doap:Project .
        ?project doap:name ?name .
        #{optional_selectors}
      } ORDER BY ?programming_language
    )
    query.execute(@sdk_repo) do |solution|
      sdk_name = solution['name'].value
      sdk = {}
      # Use this instead of solution.each_binding to force the order
      optional_keys.each do |key|
        hash_key = key.gsub('-','_')
        begin
          value = solution[hash_key].value
        rescue => e
          $stderr.puts "Could not load #{key}... it probably has multiple values...."
          value = nil
        end
        sdk[hash_key] = value
      end
      sdks[sdk_name] = sdk
    end
    YAML::dump(sdks)
  end

  def save_simple_yaml(file)
    save file, to_simple_yaml
  end

  private
  def save(file, content)
    File.open(file, 'wb') do |f|
      f.write content
    end
  end
end
