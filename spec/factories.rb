Factory.sequence(:topic_name) { |n| "Topic #{n}" }

Factory.define :credential do |credential|
  credential.add_attribute(:type, 'Job')
  credential.title "Credential"
  credential.url "http://spot.us/"
  credential.description "Description"
  credential.association(:user)
end

Factory.define :job do |job|
  job.add_attribute(:type, 'Job')
  job.title "Job"
  job.url "http://spot.us/"
  job.description "Job Description"
  job.association(:user)
end

Factory.define :user do |user|
  user.email { random_email_address }
  user.first_name 'Billy'
  user.last_name  'Joel'
  user.add_attribute(:type, 'Citizen')
end

Factory.define :citizen do |user|
  user.email { random_email_address }
  user.first_name 'Billy'
  user.last_name  'Joel'
  user.add_attribute(:type, 'Citizen')
end

Factory.define :admin do |user|
  user.email { random_email_address }
  user.first_name 'Billy'
  user.last_name  'Joel'
  user.add_attribute(:type, 'Admin')
end

Factory.define :reporter do |user|
  user.email { random_email_address }
  user.first_name 'Reporter'
  user.last_name  'Joel'
  user.add_attribute(:type, 'Reporter')
end

Factory.define :organization do |user|
  user.email { random_email_address }
  user.first_name 'News Org'
  user.last_name  'Smith'
  user.status 'needs_approval'
  user.add_attribute(:type, 'Organization')
end

Factory.define :news_item do |news_item|
  news_item.headline "Headline"
  news_item.location { LOCATIONS.first }
  news_item.featured_image_caption "lorem ipsum"
  news_item.association(:user)
end

Factory.define :pitch do |pitch|
  pitch.headline               "Headline"
  pitch.location               { LOCATIONS.first }
  pitch.requested_amount       1000
  pitch.short_description      "lorem ipsum"
  pitch.extended_description   "lorem ipsum"
  pitch.delivery_description   "lorem ipsum"
  pitch.featured_image_caption "lorem ipsum"
  pitch.skills                 "lorem ipsum"
  pitch.keywords               "lorem ipsum"
  pitch.contract_agreement     "1"
  pitch.association(:user)
end

Factory.define :story do |story|
  story.headline               "Headline"
  story.location               { LOCATIONS.first }
  story.extended_description   "lorem ipsum"
  story.featured_image_caption "lorem ipsum"
  story.keywords               "lorem ipsum"
  story.association(:pitch)
  story.association(:user)
end

Factory.define :affiliation do |donation|
  donation.association(:tip)
  donation.association(:pitch)
end

Factory.define :donation do |donation|
  donation.association(:user)
  donation.association(:pitch)
  donation.amount 10
end

Factory.define :tip do |tip|
  tip.headline               "Headline"
  tip.location               { LOCATIONS.first }
  tip.short_description      "lorem ipsum"
  tip.keywords               "lorem ipsum"
  tip.pledge_amount          100
  tip.association(:user)
end

Factory.define :pledge do |pledge|
  pledge.association(:user)
  pledge.association(:tip)
  pledge.amount 42
end

Factory.define :purchase do |purchase|
  purchase.first_name 'John'
  purchase.last_name  'User'
  purchase.address1   '100 Happy Lane'
  purchase.address2   'Apt. 2'
  purchase.city       'Boston'
  purchase.state      'MA'
  purchase.zip        '02141'

  purchase.association :user
  purchase.credit_card_number '1'
  purchase.credit_card_month '1'
  purchase.credit_card_type  'bogus'
  purchase.credit_card_year { Time.now.year + 1 }
  purchase.verification_value '111'
end

Factory.define :credit_card, :class => ActiveMerchant::Billing::CreditCard do |cc|
  cc.first_name         'Billy'
  cc.last_name          'Joel'
  cc.number             '1'
  cc.month              '1'
  cc.year               { Time.now.year + 1 }
  cc.verification_value '111'
  cc.add_attribute(:type, 'bogus')
end

Factory.define :topic do |topic|
  topic.name { Factory.next(:topic_name) }
end

Factory.define :credit do |credit|
  credit.association(:user)
  credit.description  'A credit created by a factory'
  credit.amount   25
end


# handy builders ##################################################################################

def create_pitch_with_donations
  returning Factory(:pitch) do |p|
    Factory(:donation, :pitch => p)
    u = Factory :user
    3.times { Factory(:donation, :pitch => p, :user => u) }
    p.reload
  end
end


# helpers for factories ###########################################################################

def random_email_address
  "#{random_string}@example.com"
end

def random_string
  letters = *'a'..'z'
  random_string_for_uniqueness = ''
  10.times { random_string_for_uniqueness += letters[rand(letters.size - 1)]}
  random_string_for_uniqueness
end

