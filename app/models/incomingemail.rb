class Incomingemail < ActiveRecord::Base
	def self.parseEmail(subject, body)
		parse = subject.split[","]
		location = nil;
		sublocation = nil;
		description = nil;

		puts("parsing email")
		parse.each do |item|
			puts(item)
			id = item.split[":"][0]
			what = item.split[":"][1]
			id.downcase!
			if id.include?("what")
				description = what
				puts("description")
			elsif id.include?("where")
				location =  what
				sublocation = what
				puts("location")
			end
		end

		@info = [location, sublocation, description]
		return @info
	end

	def self.correctToEmail(email)
		return email == "3dcfe1f5df7214a766f7@cloudmailin.net"
	end
end
