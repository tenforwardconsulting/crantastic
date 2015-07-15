class DigestMailer < ActionMailer::Base
  default from: "Crantastic <cranatic@gmail.com>"

  def weekly_digest(digest)
    @digest = digest
    mail to: "r-help@r-project.org",
         date: Time.now,
         subject: "CRAN (and crantastic) updates this week"
  end

end
