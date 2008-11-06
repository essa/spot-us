class Invitation
  include Validateable

  attr_accessor :sender, :news_item, :emails, :message

  validates_presence_of     :sender, :news_item
  validates_length_of       :emails,    :within => 3..1000
  validates_format_of       :emails, :with => %r{(\S*)@(\S*)\s*(,\s*(\S*)@(\S*))*}, :allow_blank => false


  def validate
    super

    unless self.sender.kind_of?(User)
      errors.add(:sender, "is not a NewsItem")
    end
    unless self.news_item.kind_of?(NewsItem)
      errors.add(:news_item, "is not a NewsItem")
    end
  end
end
