# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#file = File.new("db/simplewiki-latest-page.sql.bac", "r")
#14.times { file.gets } # skip the first 49 lines
#
#line = file.gets
#line[0..line.index(' (')-1] = ''
#begin
#	match = line.match /\(([0-9]*),[0-9]*,'([^']*)'.*\)[,;]$/
#	id, title = match[1], match[2]
#	Page.create(id: id ,title: title)
#end while (line = file.gets)
#file.close
#puts "Pages: #{Page.count}"

#file =File.new("db/simplewiki-latest-pagelinks.sql","r")
#38.times { file.gets } # skip the first 49 lines

# backwards
#file =File.new("db/simplewiki-latest-pagelinks.sql.bac","r")
#14.times { file.gets } # skip the first 49 lines

# middle
file =File.new("db/simplewiki-latest-pagelinks.sql","r")
3000000.times { file.gets } # skip the first 49 lines


line = file.gets
#line[0..line.index(' (')] = ''

i = 0
begin
	i += 1
	match = line.match /\(([0-9]*),[0-9]*,'(.*)'\)[,;]$/
	id, title = match[1], match[2]
	
	begin
		to_id=Page.find_by_title(title).id
		from_id=Page.find_by_id(id).id
		Link.create(to_id: to_id, from_id: from_id)
	rescue
	puts "Links: #{Link.count}" if i % 1000 == 0
	end
end while (line = file.gets)
puts "Links: #{Link.count}"
