import webapp2
import base_page
from google.appengine.ext import ndb
import db_defs

class RSVP(base_page.BaseHandler):
	#overwrite init function
	def __init__(self, request, response):
		self.initialize(request, response)
		self.template_values = {} #start with empty dictionary


	def render(self, page):
		#returns list of RSVPs
		self.template_values['events']=[{'name':x.name, 'key':x.key.urlsafe()} for x in db_defs.Event.query().fetch()]
		self.template_values['RSVPs'] = [{'name':x.name,'key':x.key.urlsafe()} for x in db_defs.RSVP.query(ancestor=ndb.Key(db_defs.RSVP, self.app.config.get('default-group'))).fetch()]
		base_page.BaseHandler.render(self, page, self.template_values)

	def get(self):
		self.render('rsvp.html')

	def post(self):
		action = self.request.get('action')
		if action == 'add_rsvp':
			k = ndb.Key(db_defs.RSVP, self.app.config.get('default-group'))
			rsvp = db_defs.RSVP(parent=k)
			rsvp.name = self.request.get('rsvp-name')
			rsvp.answer = bool(self.request.get('rsvp-answer'))
			rsvp.number = int(self.request.get('rsvp-number'))
			rsvp.events = [ndb.Key(urlsafe=x) for x in self.request.get_all('rsvp-events')]
			rsvp.food = self.request.get('rsvp-food')
			rsvp.email = self.request.get('rsvp-email')
			rsvp.put() #save RSVP
			self.template_values['message'] = rsvp.name + ' has RSVPed!'
		else:
			self.template_values['message'] = 'Action ' + action + ' is unknown.'
		
		self.render('rsvp.html')