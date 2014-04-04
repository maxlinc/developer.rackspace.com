require 'json/ld'
require 'yaml'
require 'rdf'
require 'rdf/raptor'
require 'sparql'

# Hack!  Raptor needed and ruby doesn't find the lib after a homebrew install
ENV['DYLD_LIBRARY_PATH'] = '/opt/boxen/homebrew/Cellar/raptor/2.0.13/lib'

class DOAPConverter
  include RDF
  COMPACT_CONTEXT = JSON.parse %({
  "@context": {
    "dct": "http://purl.org/dc/terms/",
    "doap": "http://usefulinc.com/ns/doap#",
    "sioc": "http://rdfs.org/sioc/ns#",
    "foaf": "http://xmlns.com/foaf/0.1/",
    "skos": "http://www.w3.org/2004/02/skos/core#",
    "rdfohloh": "http://rdfohloh.wikier.org/ns#",
    "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
    "xsd": "http://www.w3.org/2001/XMLSchema#",
    "owl": "http://www.w3.org/2002/07/owl#",
    "dc": "http://purl.org/dc/elements/1.1/",
    "vcard": "http://www.w3.org/2001/vcard-rdf/3.0#"
  }
})

  def initialize
    @sdk_repo = RDF::Repository.new
  end

  def load(rdf_url)
    @sdk_repo.load rdf_url

    # @graph = RDF::Reader.open(rdf_url) do |reader|
    #   reader.each_statement do |statement|
    #     puts statement.inspect
    #   end
    # end
  end

  def to_json_ld
    compacted = nil
    JSON::LD::API::fromRdf(@sdk_repo) do |expanded|
      compacted = JSON::LD::API.compact(expanded, COMPACT_CONTEXT['@context'])
    end
    JSON.pretty_generate compacted['@graph']
  end

  def to_simple_yaml
    sdks = []
    query = SPARQL.parse %(
      PREFIX doap: <http://usefulinc.com/ns/doap#>
      select ?name ?homepage ?programming_language ?description ?shortdesc ?maintainer
        ?download_page ?license ?category ?bug_database ?mailing_list ?repository
      WHERE {
        ?x a doap:Project .
        ?x doap:name ?name .
        OPTIONAL { ?x doap:homepage ?homepage . }
        OPTIONAL { ?x doap:programming-language ?programming_language . }
        OPTIONAL { ?x doap:description ?description . }
        OPTIONAL { ?x doap:shortdesc ?shortdesc . }
        OPTIONAL { ?x doap:maintainer ?maintainer . }
        OPTIONAL { ?x doap:download-page ?download_page . }
        OPTIONAL { ?x doap:license ?license . }
        OPTIONAL { ?x doap:category ?category . }
        OPTIONAL { ?x doap:bug-database ?bug_database . }
        OPTIONAL { ?x doap:mailing-list ?mailing_list . }
        OPTIONAL { ?x doap:repository ?repository . }
      }
    )
    query.execute(@sdk_repo) do |solution|
      sdk = {}
      solution.each_binding { |name, value|
        begin
          puts "#{name} = #{value.value}"
          sdk[name.to_s] = value.value
        rescue => e
          $stderr.puts "Could not load #{name}... it probably has multiple values...."
        end
      }
      sdks.push sdk
    end
    YAML::dump(sdks)
  end

  def save_json_ld(file)
    save file, to_json_ld
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

converter = DOAPConverter.new
# converter.load "http://rdfohloh.wikier.org/project/pyrax.rdf"
converter.load "https://pypi.python.org/pypi?:action=doap&name=pyrax"
converter.load "http://rdfohloh.wikier.org/project/jclouds.rdf"
converter.load "http://svn.apache.org/repos/asf/libcloud/trunk/doap_libcloud.rdf"
converter.save_simple_yaml 'site_source/_data/sdks.yml'
# converter.save_json_ld 'site_source/_data/sdks.json'

