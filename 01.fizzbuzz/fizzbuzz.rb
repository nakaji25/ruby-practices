(1..20).each do |n|
  if (n % 3 != 0) &&  (n % 5 != 0)
    puts n
  elsif (n % 5 != 0) && (n % 3 == 0)
    puts "Fizz"
    elsif (n % 5 == 0) && (n % 3 != 0)
      puts "Buzz"
    else
      puts "FizzBuzz"
  end
end
