import webapp2
import base_page
from google.appengine.ext import ndb
import db_defs

class ViewRSVP(base_page.BaseHandler):
	def __init__(self, request, reponse):
		self.initialize(request, reponse)
		self.template_values = {}

	def get(self):
		if self.request.get('type') == 'view':
			#get key
			rsvp_key = ndb.Key(urlsafe=self.request.get('key'))
			rsvp = rsvp_key.get() #rsvp object
			self.response.write('Name: ')	
			self.response.write(rsvp.name)
			self.response.write('<br>')
			self.response.write('Number in your party: ')
			self.response.write(rsvp.number)
			self.response.write('<br>')
			self.response.write('<br>')

			if rsvp.answer == True:
				self.response.write('You are Attending: <br>')
				
				events = db_defs.Event.query().fetch()
			
				for e in events:
					if e.key in rsvp.events:
						self.response.write(e.name)
						self.response.write('<br>')
				self.response.write('<br>')
				self.response.write('Email: ')
				self.response.write(rsvp.email)
				self.response.write('<br>')
				self.response.write('Food Choice: ')
				self.response.write (rsvp.food)
			else:
				self.response.write('You are not attending <br>')	