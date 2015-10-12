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
			if rsvp.answer == True:
				self.response.write('You are Attending <br>')
				self.response.write('Number in your party: ')
				self.response.write(rsvp.number)
				self.response.write('<br>')
				self.response.write('Email: ')
				self.response.write(rsvp.email)
				self.response.write('<br>')
				self.response.write('Food Choices: ')
				self.response.write('<br>')
				for x in rsvp.foods:
					self.response.write(x)
					self.response.write('<br>')
			else:
				self.response.write('You are not attending <br>')	