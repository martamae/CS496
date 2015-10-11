import webapp2

application = webapp2.WSGIApplication([
	('/', base_page.HelloWorld'),
], debug = True)