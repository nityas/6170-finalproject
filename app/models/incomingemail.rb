class Incomingemail < ActiveRecord::Base
	def self.parseEmail(subject, body)
		@info = Array.new(3)
		parse = subject.split[","]

		parse.each do |item|
			id = item.split[":"][0]
			what = item.split[":"][1]
			id.downcase!
			if id.include?("what")
				@info[0] = what
			elsif id.include?("where")
				@info[1] =  what
				@info[2] = what
			end
		end
	end

	def self.correctToEmail(email)
		return email == "3dcfe1f5df7214a766f7@cloudmailin.net"
	end
end
