# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

titles = ['Hitler', 'WWII', 'Tupac']

titles.each do |title|
  puts "Creating #{title}"
  Page.create({title: title})
end

Page.all.each do |from|
  Page.all.each do |to|
    puts "linking #{from.title} to #{to.title}"
    Link.create({from_id: from.id, to_id: to.id}) if from != to
  end
end

puts "#{Page.count} pages"
puts " #{Link.count} links"

