
class Parser

  cattr_accessor :pages, :queries

  @@pages = 0
  @@queries = 0

  def initialize(field_value)
    @field_value = field_value
  end

  def calculate_relavance_hash
    array = @field_value.split(/\s/)
    if array[0] == 'P'
      @@pages+=1
      array[1..-1].each_with_index do |keyword, index|
        Search.pages_keywords_relavance['P' + @@pages.to_s]||=Hash.new(0)
        Search.pages_keywords_relavance['P' + @@pages.to_s][keyword] = (Search::MAX-index)
      end
    elsif array[0] == 'Q'
      @@queries+=1
      array[1..-1].each_with_index do |keyword, index|
        Search.query_keywords_relavance['Q' + @@queries.to_s]||=Hash.new(0)
        Search.query_keywords_relavance['Q' + @@queries.to_s][keyword] = (Search::MAX-index)
      end
    else
      return
    end
  end


end