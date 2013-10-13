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
    if n == 1
      return [self]
    else
      children = self.links.map do |link|
        p link.to
        link.to.nearest(n-1)
      end
      return children.flatten(1).push(self)
    end
  end
end
