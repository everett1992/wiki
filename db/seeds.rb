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

page_ids = Page.all.map(&:id)

line = file.gets
line[0..line.index(' (')] = ''
n = 0
i = 0
while(n < 10_000)
	puts i if i % 100 == 0
	i += 1
	match = line.match /\(([0-9]*),[0-9]*,'(.*)'\)[,;]$/
	from_id, title = match[1], match[2]
	
	begin
		to_id = Page.find_by_title(title).id
		if page_ids.include?(to_id) && page_ids.include?(from_id)
			link = Link.new(to_id: to_id, from_id: id)
			if link.valid? && from_id.nil? && to_id.nil?
				link.save
				puts "new"
				n += 1
			end
		end
	rescue
	end
	line = file.gets
end
puts "Links: #{Link.count}"
