class Incomingemail < ActiveRecord::Base
	def parseEmail(subject, body)
		@info = nil
		parse = subject.split[","]
		parse.each do |item|
			what = item.split[":"]
			if item[0].downcase!.include("what")?
				@info[0] = item[1]
			elsif item[0].downcase!.include("where")?
				@info[1] =  item[1]
				@info[2] = item[1]
			end
		end
	end

	def correctToEmail(email)
		return email == "3dcfe1f5df7214a766f7@cloudmailin.net"
	end
end
