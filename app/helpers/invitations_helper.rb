
module InvitationsHelper
  # messages shown above the send button
  Messages = {
    # shown while typing mail addresses if they are valid
    :valid => "address is valid",
    # shown while typing mail addresses if they are invalid
    :invalid => "address is invalid",
    # shown while sending mail
    :sending => "...sending...",
    # shown after mail was sent
    :sent => "Thank you, mail was sent",
    # shown if error happens while sending mails
    :error => "error happened while sending your mail",
  }
end

