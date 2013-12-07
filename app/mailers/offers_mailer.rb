class OffersMailer < ActionMailer::Base
	default :from => "offers@bytemap.com"

	def offer_mail(offer)
		potentialMails = Subscription.select("user_id").where(location_id: offer.location_id)

		# send mail if location has at least 1 subscriber
		unless potentialMails.empty?
			mails = potentialMails.collect { |user| User.find(user.user_id).phoneNumber.to_s + User.find(user.user_id).provider}
			@offer = offer
			@mail = mail(:to => mails,:subject => "")
			@mail.deliver
		end
	end
end
