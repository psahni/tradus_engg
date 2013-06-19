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
      Parser.new(page_field_value).calculate_relavance_hash
    end
  end

  def process_results
    Rails.logger.info "======== Relavance Hash ==============="
    Rails.logger.info Search.pages_keywords_relavance.inspect
    Rails.logger.info Search.query_keywords_relavance.inspect

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
      Search.output[query] = Search.output[query].sort_by{|page, rel| rel}.reverse
    end
  end

end