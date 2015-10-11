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
		self.template_values['RSVPs'] = [{'name':x.name,'key':x.key.urlsafe()} for x in db_defs.RSVP.query().fetch()]
		base_page.BaseHandler.render(self, page, self.template_values)

	def get(self):
		self.render('rsvp.html')

	def post(self):
		action = self.request.get('action')
		if action == 'add_rsvp':
			k = ndb.Key(db_defs.RSVP, self.app.config.get('default-group'))
			rsvp = db_defs.RSVP(parent=k)
			rsvp.name = self.request.get('rsvp-name')
			rsvp.number = self.request.get('rsvp-number')
			rsvp.put() #save RSVP
			self.template_values['message'] = rsvp.name + ' has RSVPed!'
		else:
			self.template_values['message'] = 'Action ' + action + ' is unknown.'
		
		self.render('rsvp.html')