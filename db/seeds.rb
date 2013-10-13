# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#file = File.new("db/enwiki-latest-page.sql", "r")
#49.times { file.gets } # skip the first 49 lines
#
#line = file.gets
#line[0..line.index(' (')-1] = ''
#10_000.times do
#	match = line.match /\(([0-9]*),[0-9]*,'([^']*)'.*\)[,;]$/
#	id, title = match[1], match[2]
#	page = Page.new(id: id ,title: title)
#	page.save if page.valid?
#	line = file.gets
#end
#file.close
#puts "Pages: #{Page.count}"

file =File.new("db/enwiki-latest-pagelinks.sql","r")
38.times { file.gets } # skip the first 49 lines

line = file.gets
line[0..line.index(' (')] = ''
n = 0
while(n < 10_000)
	n += 1
	match = line.match /\(([0-9]*),[0-9]*,'(.*)'\)[,;]$/
	id, title = match[1], match[2]
	
	begin
		to_id=Page.find_by_title(title).id
		from_id=Page.find_by_id(id).id
		link = Link.create(to_id: to_id, from_id: id)
		if link.valid?
			link.save
		else
			n -= 1
		end
	rescue
		n -= 1
	end
	line = file.gets
end
puts "Links: #{Link.count}"
