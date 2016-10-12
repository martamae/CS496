import webapp2
from google.appengine.ext import ndb
import db_defs
import base_page

class EditRSVP(base_page.BaseHandler):
	def post(self):
		rsvp_key = ndb.Key(urlsafe=self.request.get('key'))
		rsvp = rsvp_key.get()
		rsvp.name = self.request.get('rsvp-name')
		rsvp.answer = bool(self.request.get('rsvp-answer'))
		rsvp.events = [ndb.Key(urlsafe=x) for x in self.request.get_all('rsvp-events')]
		rsvp.food = self.request.get('rsvp-food')
		rsvp.number = int(self.request.get('rsvp-number'))
		rsvp.email = self.request.get('rsvp-email')
		rsvp.put()
		self.redirect('/rsvp')