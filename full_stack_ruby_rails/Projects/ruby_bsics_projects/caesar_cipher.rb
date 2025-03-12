#caps: 65 - 90
#lower: 97 - 122


def caesar_cipher(string, shift)
  begin
    string.each_char.map do |char|
      case char.ord
        when (32) then min = (32 - shift); max = 32
        when (65..90) then min = 64; max = 90
        when (97..122) then min = 65; max = 122
        else raise "\e[31m#{char} is outside the range of [a-z] or [A-Z]: \nENTRY: #{string}e\[0m"
      end

      if (char.ord + shift) > max
        (min + (shift - (max - char.ord))).chr
      else
        (char.ord + shift).chr
      end
  end.join

  rescue => e
    puts e
  end
end



puts caesar_cipher("What a& string!", 5)