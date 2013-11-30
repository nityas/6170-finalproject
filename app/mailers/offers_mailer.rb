class OffersMailer < ActionMailer::Base
	#self.async = true
	default :from => "offers@bytemap.com"
	def offer_mail(number)
		mail(:to => number)
	end
end
