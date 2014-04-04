require 'yaml'
require 'rdf'
require 'rdf/raptor'
require 'sparql'
require 'hash_deep_merge'

# Hack!  Raptor needed and ruby doesn't find the lib after a homebrew install
ENV['DYLD_LIBRARY_PATH'] = '/opt/boxen/homebrew/Cellar/raptor/2.0.13/lib'

namespace :doap do
  desc 'Clears the _data/sdks.yml file, so you can replace it with a completely generated one'
  task :clobber do
    File.open('site_source/_data/sdks.yml', 'wb') do |f|
      f.write ''
    end
  end

  desc 'Builds the _data/sdks.yml file by fetching Description of A Project for each SDK from the semantic web'
  task :build_sdk_yml do
    converter = DOAPConverter.new
    # keep custom fields and sdks that don't exist, data available in DOAP will be overwritten
    converter.load_existing 'site_source/_data/sdks.yml'
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
    @sdks = {}
  end

  def load_existing(file)
    existing_data = YAML::load(File.read(file)) || {}
    @sdks.deep_merge existing_data
  end

  def load(rdf_url)
    graph = RDF::Graph.load(rdf_url)
    @sdks.deep_merge! sdk_from_rdf graph
  end

  def to_simple_yaml
    sorted_sdks = Hash[@sdks.sort]
    YAML::dump(sorted_sdks)
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

  def sdk_from_rdf(graph)
    sdk = {}
    sdk_name = nil
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
    query.execute(graph) do |solution|
      sdk_name = solution['name'].value
      # Use this instead of solution.each_binding to force the order
      optional_keys.each do |key|
        hash_key = key.gsub('-','_')
        begin
          value = solution[hash_key].value
          sdk[hash_key] = value if value
        rescue => e
          $stderr.puts "Could not load #{key}... it probably has multiple values...."
        end
      end
    end
    { sdk_name => sdk }
  end
end