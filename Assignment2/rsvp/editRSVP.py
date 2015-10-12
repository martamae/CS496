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
		rsvp.number = int(self.request.get('rsvp-number'))
		rsvp.foods = self.request.get_all('rsvp-food')
		rsvp.email = self.request.get('rsvp-email')
		self.redirect('/edit?key=' + rsvp_key.urlsafe() + '&type=rsvp')