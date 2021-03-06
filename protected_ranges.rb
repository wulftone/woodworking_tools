# The scenario this was built to solve is this:
#
# I had an 11 foot piece of wood I wanted to mount under my cabinets
# but there were selected locations I knew I did NOT want to drill
# into.  I wanted to find a nice, even interval of some number of
# holes, but with a set distance in from either end of the stock.
#
# Goal:
#   Find a number of screws that divides into a list of measurements
#   that all lie outside some list of protected ranges
#
# TODO: Make it take command line arguments instead of hard-coded values

require 'pry-byebug'
require 'awesome_print'

# The total length of the piece we're drilling
stock_length = 132 # in inches
# We have an offset of 2" to remove as an arbitrary starting point for screw holes
offset = 2
# We also want to stop the same distance from the other end of the stock
cutoff = offset
# Here is the length we're actually checking against
length = stock_length - offset - cutoff

# Distance in inches as measured from one end of stock:
# These have some buffer built in, so anything outside of
# these ranges, even if it is very close, is acceptable
protected_ranges = [
  9..12,
  39..42,
  57..60,
  81..84,
  111..114
]

min = 1
max = 10
screws = min..max

# Generate a list of measurements for each number of screws
locations = screws.map do |n|
  interval     = length.to_f / n
  measurements = [offset] # We always start at the initial offset

  n.times { |i| measurements.push interval + measurements[i] }

  measurements
end

# Remove any location lists
result = locations.reject do |set|
  # Where any of the locations
  set.any? do |s|
    # Are in the protected ranges
    protected_ranges.any? do |r|
      r.cover? s
    end
  end
end

puts "You had an offset of #{offset}\" from either end of the stock."
puts "Total stock length is #{stock_length}\"\n\n"
puts "You can use the following measurements:\n\n"

result.each do |r|
  puts "#{r.length} Holes:"
  puts "    Measurements: #{r.map { |i| i.round 3 }.join('", ')}\""
  puts "    Interval: #{(r[1] - r[0]).round 3}\""
end
