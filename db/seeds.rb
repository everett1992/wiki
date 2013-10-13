# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

file = File.new("db/page.sql", "r")
49.times { file.gets } # skip the first 49 lines

line = file.gets
line[0..line.index(' (')-1] = ''
begin
	match = line.match /\(([0-9]*),[0-9]*,'([^']*)'.*\)[,;]$/
	id, title = match[1], match[2]
	Page.create(id: id ,title: title)
end while (line = file.gets)
file.close
puts "Pages: #{Page.count}"

file =File.new("db/pagelinks.sql","r")
38.times { file.gets } # skip the first 49 lines

line = file.gets
line[0..line.index(' (')] = ''
begin
	match = line.match /\(([0-9]*),[0-9]*,'(.*)'\)[,;]$/
	id, title = match[1], match[2]
	
	to_id=Page.find_by_title(title).id
	Link.create(to_id: to_id, from_id: id)
end while (line = file.gets)
puts "Links: #{Link.count}"