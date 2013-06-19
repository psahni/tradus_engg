
class Page < Struct.new(:page, :value, :query)
end

class Search

  cattr_accessor :pages_keywords_relavance, :query_keywords_relavance, :output

  MAX = 8

  def initialize(args, &block)
    Search.pages_keywords_relavance, Search.query_keywords_relavance = {}, {}
    calculate_relavance(args)
    yield process_results
  end


  def calculate_relavance(field_values)
    Parser.pages, Parser.queries   = [0, 0]
    field_values.each do |page_field_value|
      Parser.new(page_field_value).calculate_relavance_hash unless page_field_value.blank?
    end
  end



  #######################################################################################################
  #
  #######################################################################################################


  def process_results
    Search.output = {}
    raise "Not Valid" if ( Search.query_keywords_relavance.blank? || Search.pages_keywords_relavance.blank? )
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

  ####################################################################################################
  # There is another way to do, where we form an array of P elements, and Q elements
  # Then We run through P ( that contains P1, P2...) for every Q element ( Q1, Q2, ...) and
  # then we find common elements array and fetch relavance and so on...
  #####################################################################################################

  private

  def self.sort_by(output)
    Rails.logger.info output.inspect
    output_array = []
    temp = {}
    output.each_key do |query|
      output[query].each do |page, value|
        (temp[query]||=[]) << (Page.new(page, value,query))
      end
    end
    temp.each_key{|key| output_array.push( temp[key].sort_by{|page| [-page.value, page.page] } ) }
    output_array
  end

end

 #def sort_by_page_and_value(array)
 #  array.sort!{|page1, page2| page2.value <=> page1.value}
 #  size = array.size-1
 #  size.times do |i|
 #    index_min = i
 #    (i + 1).upto(size) do |j|
 #      index_min = j if ((array[j].page < array[index_min].page) && (array[j].value == array[index_min].value) )
 #    end
 #    array[i], array[index_min] = array[index_min], array[i] if index_min!=i
 #  end
 # return array
 #end
