require 'net/http'
require 'net/https' # for ruby 1.8.7
require 'json'

module BRPopulate
  def self.states
    http = Net::HTTP.new('raw.githubusercontent.com', 443); http.use_ssl = true
    JSON.parse http.get('/rockcontent/br_populate/master/states.json').body
  end

  def self.populate
    brazil = Country.find_by(name: "Brasil")

    states.each do |state|
      state_obj = State.new(:code => state["acronym"], :name => state["name"], :country => brazil)
      state_obj.save

      state["cities"].each do |city|
        c = City.new(name: city["name"], state: state_obj)
        c.save
      end
    end
  end
end

BRPopulate.populate
