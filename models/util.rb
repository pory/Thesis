class Util
  class << self

    def remove_diacritics string
      str = string.dup
      accents = { 
        ['á','à','â','ä','ã'] => 'a',
        ['Ã','Ä','Â','À','�?'] => 'A',
        ['č','Č'] => 'c',
        ['ň','Ň'] => 'n',
        ['š','Š'] => 's',
        ['ě','Ě'] => 'e',
        ['ř','Ř'] => 'r',
        ['ť','Ť'] => 't',
        ['ž','Ž'] => 'z',
        ['ý','Ý'] => 'y',
        ['á','Á'] => 'a',
        ['í','Í'] => 'i',
        ['í','Í'] => 'i',
        ['ď','Ď'] => 'd',
        ['ů','ú','Ú'] => 'u',
        ['é','è','ê','ë'] => 'e',
        ['Ë','É','È','Ê'] => 'E',
        ['í','ì','î','ï'] => 'i',
        ['�?','Î','Ì','�?'] => 'I',
        ['ó','ò','ô','ö','õ'] => 'o',
        ['Õ','Ö','Ô','Ò','Ó'] => 'O',
        ['ú','ù','û','ü','ů'] => 'u',
        ['Ú','Û','Ù','Ü','Ǔ'] => 'U',
        ['ç'] => 'c', ['Ç'] => 'C'
      }
      accents.each do |ac,rep|
        ac.each do |s|
          str = str.gsub(s, rep)
        end
      end
      return str
    end    
    
    def compose_url string
        str = remove_diacritics(string.dup)
        str = str.gsub(/[^a-zA-Z0-9 -]/,"")
        
        str = str.gsub(/[ ]+/," ")
        
        str = str.gsub(/ \- /,"-")
        str = str.gsub(/ \-/,"-")
        str = str.gsub(/\- /,"-")
        str = str.gsub(/ /,"-")
        
        str = str.downcase
    end  
  
  end
end