require 'json'

# we assume if neither person has any meetings the day is off. if this is not an assumption
# we can make all hours available for any day that is not accounted for in the method.

filepath_andy = 'input_andy.json'
filepath_sandra = 'input_sandra.json'

serialized_dates_andy = File.read(filepath_andy)
serialized_dates_sandra = File.read(filepath_sandra)
#create the array of hashes
andy_availability = JSON.parse(serialized_dates_andy)
sandra_availability = JSON.parse(serialized_dates_sandra)

# get an array of all dates working
def get_dates(array)
  days = []
  array.each do |day|
    days << day['start'].match(/\d{2}T/)[0].split('').first(2).join.to_i
  end
  days.uniq
end

# p get_dates(andy_availability) == [1, 2, 3, 4]


# getting the time in two decimals
def getting_time(string)
  string.match(/T.{2}/)[0][1..-1].to_i
end

# p getting_time("2022-08-02T09:00:00") == 9

# create an array of arrays containing specific work days
def daily_schedule(array)
  days_working = get_dates(array)
  day_one_array = []
  day_two_array = []
  day_three_array = []
  day_four_array = []
  day_five_array = []
  array.each do |item|
    if item['start'].match(/\d{2}T/)[0].split('').first(2).join.to_i == days_working[0]
      day_one_array << item
    elsif item['start'].match(/\d{2}T/)[0].split('').first(2).join.to_i == days_working[1]
      day_two_array << item
    elsif item['start'].match(/\d{2}T/)[0].split('').first(2).join.to_i == days_working[2]
      day_three_array << item
    elsif item['start'].match(/\d{2}T/)[0].split('').first(2).join.to_i == days_working[3]
      day_four_array << item
    elsif item['start'].match(/\d{2}T/)[0].split('').first(2).join.to_i == days_working[4]
      day_five_array << item
    end
  end
  [day_one_array, day_two_array, day_three_array, day_four_array, day_five_array]
end

# p daily_schedule(andy_availability) == "array of arrays, in which each array contains hashes of specific time frames"


#given the array of arrays, we will turn each day into simple two decimal numbers, even indexs
# will be starting times and odd ending. easier to manipulate
def simple_time_per_day(array)
  daily = daily_schedule(array)
  day_one_simple = []
  day_two_simple = []
  day_three_simple = []
  day_four_simple = []
  day_five_simple = []
  daily.each_with_index do |day, index|
    if index == 0
      day.each do |period|
        day_one_simple << getting_time(period['start'])
        day_one_simple << getting_time(period['end'])
      end
    elsif index == 1
      day.each do |period|
        day_two_simple << getting_time(period['start'])
        day_two_simple << getting_time(period['end'])
      end
    elsif index == 2
      day.each do |period|
        day_three_simple << getting_time(period['start'])
        day_three_simple << getting_time(period['end'])
      end
    elsif index == 3
      day.each do |period|
        day_four_simple << getting_time(period['start'])
        day_four_simple << getting_time(period['end'])
      end
    elsif index == 4
      day.each do |period|
        day_five_simple << getting_time(period['start'])
        day_five_simple << getting_time(period['end'])
      end
    end
  end
  return [day_one_simple, day_two_simple, day_three_simple, day_four_simple, day_five_simple]
end

# p simple_time_per_day(sandra_availability) == "Array of arrays containing the start and end times swithing each index"


# create an array of all working hours for a day, broken into one hour time periods.
def array_of_working_hours(array)
  if array.length == 2
    return (array[0]...array[1]).to_a
  elsif array.length == 4
    return [(array[0]...array[1]).to_a, (array[2]...array[3]).to_a]
  elsif array.length == 6
    return [(array[0]...array[1]).to_a, (array[2]...array[3]).to_a, (array[4]...array[5]).to_a]
  elsif array.length == 8
    return [(array[0]...array[1]).to_a, (array[2]...array[3]).to_a, (array[4]...array[5]).to_a, (array[6]...array[7]).to_a]
  end
end


# combine arrays together for a day. example: [[9,10,], [14,15,16]] => [9,10,14,15,16]
def combine_array(array)
  if array.length <= 4
    array.reduce([], :concat)
  else
    array
  end
end

# find unique values from the two arrays and combine them for all working hours of a day
def unique_array(arr1, arr2)
  (arr1 + arr2).uniq
end

# iterate over each day, to make an array of arrays for each hour for the week
def all_working_hours(array)
  new_array = []
  array.each do |a|
    new_array << array_of_working_hours(a)
  end
  new_array
end

# given array of arrays, make each day into a single array of each busy hour
def combine_arrays(array)
  new_array = []
  array.each do |a|
    new_array << combine_array(a)
  end
  new_array
end

# find available times
def available_times(array)
  all_times = [9,10,11,12,13,14,15,16,17]
  array.each do |time|
  all_times.delete_at all_times.find_index(time)
  end
  all_times
end

# available times for each day, given an array of arrays
def available_times_per_day(array)
  array_of_busy_times = combine_arrays(all_working_hours(simple_time_per_day(array)).compact)
  available_hours = []
  array_of_busy_times.each do |day|
    available_hours << available_times(day)
  end
  available_hours
end

# creating a new array of items that are presnt in both
def when_both_include(arr, arr2)
  new_array = []
  arr.each do |number|
    new_array << number if arr2.include?(number)
  end
  new_array
end

# create available times with two arrays of arrays of available times
def combined_available_times(arr1, arr2)
  person1_available = available_times_per_day(arr1)
  person2_available = available_times_per_day(arr2)
  array = []
  (0..person1_available.length - 1).each do |i|
    array << when_both_include(person1_available[i], person2_available[i])
  end
  array
end

# create a hash of available times
def hash_of_times_with_arrays(arr1, arr2)
  all_times = combined_available_times(arr1, arr2).compact
  changing_empty_array = []
  all_times.each do |time|
    if time.length > 0
      changing_empty_array << time
    else
      changing_empty_array << "No available times"
    end
  end
  hash = {}
  (0..changing_empty_array.length - 1).each do |i|
      hash.merge!("Day #{get_dates(arr1)[i]} Starting Time" => changing_empty_array[i])
  end
  hash
end

# available slots are broken into one hour intervals
def final_output(array_one, array_two, duration)
  return hash_of_times_with_arrays(array_one, array_two) if duration == 1
end

p final_output(sandra_availability, andy_availability, 1)
