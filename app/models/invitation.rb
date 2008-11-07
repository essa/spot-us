class Invitation
  include Validateable

  attr_reader :emails, :email_addresses_text
  attr_accessor :sender, :news_item, :message

  validates_presence_of     :sender, :news_item
  validates_length_of       :email_addresses_text, :within => 3..1000

  UserName = '[^@\s]+'
  DomainName = '(?:[-a-z0-9]+\.)+[a-z]{2,}'
  EmailsRegexp = %r{\A\s*(#{UserName}@#{DomainName})\s*(,\s*(#{UserName}@#{DomainName}))*\s*\Z}

  validates_format_of       :email_addresses_text, :with => EmailsRegexp, :allow_blank => false

  def initialize
    @email_addresses_text = nil
    @emails = []
  end

  def validate
    super

    unless self.sender.kind_of?(User)
      errors.add(:sender, "is not a NewsItem")
    end
    unless self.news_item.kind_of?(NewsItem)
      errors.add(:news_item, "is not a NewsItem")
    end
  end

  def email_addresses_text=(text)
    @email_addresses_text = text
    parse_email_addresses
  end

  private

  def parse_email_addresses
    if @email_addresses_text =~ EmailsRegexp
      p Regexp.last_match.to_a
      @emails << Regexp.last_match(0)
    end
  end
end
