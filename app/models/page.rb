class Page < ActiveRecord::Base
  has_many :links, :foreign_key => 'from_id'

  validates_uniqueness_of :title
  validates_presence_of :title

  # gets all links for a set of pages
  def self.get_links(pages)
    p pages.map(&:id)
    return Link.where({from_id: pages.map(&:id), to_id: pages.map(&:id)})
  end

  # returns a graph of the n clostest pages
  def limited_closure(title)
    new_stack = [self]
    stack = []
    while (page = new_stack.pop)
      next if stack.include? page

      stack.push(page)
      found = true if page.title == title
      page.links.each { |link| new_stack.push(link.to) } if !found
    end
    return stack
  end

  # Add n generations of pages
  def nearest(n)
    new_stack = [self]
    stack = []
    n.times do 
      next_stack = []
      while(page = new_stack.pop)
        next if stack.include? page
        stack.push(page)
	page.links.map(&:to).each { |a| next_stack.push a }
      end
      new_stack = next_stack
    end
    return stack
  end
end
