class Incomingemail < ActiveRecord::Base
	def parseEmail(subject, body)
		puts body
	end

	def correctToEmail(email)
		return email == "3dcfe1f5df7214a766f7@cloudmailin.net"
	end
end
