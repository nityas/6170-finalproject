class OffersMailer < ActionMailer::Base
	default :from => "offers@bytemap.com"
	def offer_mail(offer)
		potentialMails = Subscription.select("user_id").where(building_id: offer.location_id)
		mails = potentialMails.collect { |user| User.find(user.user_id).phoneNumber.to_s + User.find(user.user_id).provider}
		@offer = offer
		mail(:to => mails,:subject => "")
	end
end
