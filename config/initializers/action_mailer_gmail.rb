ActionMailer::Base.smtp_settings = {
	:address   => "smtp.gmail.com",
	:port      =>  587,
	:domain    =>  "bytemap.com",
	:user_name =>  "ido.p.efrati",
	:password  =>  "ssj2ssj3",
	:authentication  => "plain",
	:enable_starttls_auto => true
}