def input_space(string)
  word1 = ""
  word2 = ""
  uppcase_counter = 1
  str_arr = string.chars
  str_arr.each do |c|
    if c == c.upcase and uppcase_counter != 2
      uppcase_counter = 2
      word1 += c
    elsif c != c.upcase and uppcase_counter == 2
      word1 += c
    elsif c == c.upcase and uppcase_counter == 2
      uppcase_counter = 3
      word2 += c
    elsif c != c.upcase and uppcase_counter == 3
      word2 += c
    end
  end
  string = word1 + " " + word2
  
  return string
end
