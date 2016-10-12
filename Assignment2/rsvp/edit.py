import webapp2
import base_page
from google.appengine.ext import ndb
import db_defs

class Edit(base_page.BaseHandler):
	def __init__(self, request, reponse):
		self.initialize(request, reponse)
		self.template_values = {}

	def get(self):
		if self.request.get('type') == 'rsvp':
			#get key
			rsvp_key = ndb.Key(urlsafe=self.request.get('key'))
			rsvp = rsvp_key.get() #rsvp object
			self.template_values['rsvp'] = rsvp
			self.template_values['rsvp_name'] = rsvp.name
			self.template_values['rsvp_answer'] = rsvp.answer
			self.template_values['rsvp_number'] = rsvp.number
			self.template_values['rsvp_email'] = rsvp.email
			self.template_values['rsvp_food'] = rsvp.food
			
			events = db_defs.Event.query().fetch()
			
			event_boxes = []
			for e in events:
				if e.key in rsvp.events:
					event_boxes.append({'name': e.name, 'key': e.key.urlsafe(), 'checked':True})
				else:
					event_boxes.append({'name': e.name, 'key': e.key.urlsafe(), 'checked':False})
			self.template_values['events'] = event_boxes
		self.render('edit.html', self.template_values)
		


