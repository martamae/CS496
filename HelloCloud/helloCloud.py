import webapp2
from datetime import datetime

class MainHandler(webapp2.RequestHandler):
    def get(self):
	    self.response.write(datetime.now())

app = webapp2.WSgiApplication([
	('/', MainHandler)
], debug=True