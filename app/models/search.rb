class Search

  cattr_accessor :pages_keywords_relavance, :query_keywords_relavance, :output

  MAX = 8

  @@pages_keywords_relavance, @@query_keywords_relavance, @@output = Hash.new(), Hash.new(), Hash.new()

  def initialize(args, &block)
    calculate_relavance(args)
    process_results
    yield '', "X No results"
  end


  def calculate_relavance(field_values)
    field_values.each do |page_field_value|
      Parser.new(page_field_value).calculate_relavance_hash unless page_field_value.blank?
    end
    Parser.pages   = 0
    Parser.queries = 0
  end

  def process_results
    #Rails.logger.info "======== Relavance Hash ==============="
    #Rails.logger.info Search.pages_keywords_relavance.inspect
    #Rails.logger.info Search.query_keywords_relavance.inspect
    Search.output = {}
    Search.query_keywords_relavance.each do |query, keyword_rela|
      keyword_rela.keys.each do |key|
        Search.pages_keywords_relavance.keys.each do |page|
          if Search.pages_keywords_relavance[page][key]!=0
             relavance = Search.pages_keywords_relavance[page][key]*Search.query_keywords_relavance[query][key]
             Search.output[query]||=Hash.new(0)
             Search.output[query][page]+= relavance
          end
        end
      end
    end
    Search.sort_by(Search.output)
  end

  def self.sort_by(output)
    Rails.logger.info output.inspect
    output_array = []
    temp = {}
    output.each_key do |query|
      output[query].each do |page, value|
        temp[query]||=[]
        temp[query] << (Page.new(page, value,query))
      end
    end

    temp.each_key do |key|
      output_array << temp[key].sort{|page1, page2| page2.value <=> page1.value}
    end
    Rails.logger.info output_array.inspect
  end
end

class Page < Struct.new(:page, :value, :query)
end