def get_pins(observed)
  options = {
    '0' => ['0', '8'],
    '1' => ['1', '2', '4'],
    '2' => ['2', '1', '3', '5'],
    '3' => ['3', '2', '6'],
    '4' => ['4', '1', '5', '7'],
    '5' => ['5', '2', '4', '6', '8'],
    '6' => ['6', '3', '5', '9'],
    '7' => ['7', '4', '8'],
    '8' => ['8', '5', '7', '9', '0'],
    '9' => ['9', '6', '8']
  }

  pins = observed.strip.split('')
  combinations = []

  pins.each_with_index do |pin, idx|
    if combinations.empty?

      options[pin].each do |option|
        combinations << option
      end

    else
      temp = []
      temp << [idx, []]

      combinations.each do |combination|
        options[pin].each do |option|

          combo = combination.dup <<  option
          temp[0][1] << combo

        end
      end

      combinations = temp[0].flatten.drop(1)

    end
  end
  return combinations
end

result = get_pins("369")
expected = ["339","366","399","658","636","258","268","669","668","266","369","398","256","296","259","368","638","396","238","356","659","639","666","359","336","299","338","696","269","358","656","698","699","298","236","239"]
if result.sort == expected.sort
  puts "PASS"
else
  puts "FAIL"
  puts "diff?"
  puts result.difference(expected)
end