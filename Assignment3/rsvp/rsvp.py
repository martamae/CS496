import webapp2
from google.appengine.ext import ndb
import db_defs
import json

class RSVP(webapp2.RequestHandler):
	def post(self):
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not Acceptable, API only supports json"
			return

		new_guest = db_defs.Guest()
		name = self.request.get('name', default_value=None)
		a = self.request.get('answer', default_value=None)
		if a:
			if a == "False":
				answer = False
			elif a == "True":
				answer = True
			else:
				self.response.status = 404
				self.response.status_message = "Invalid request: must specify guest's answer"
				return
		new_guest.answer = answer
		n = self.request.get('number', default_value=None)
		if n:
			number = int(n)
		else:
			number = n
		food = self.request.get('food', default_value=None)
		email = self.request.get('email', default_value=None)

		if name:
			new_guest.name = name
		else:
			self.response.status = 404
			self.response.status_message = "Invalid request: must specify guest's name"
			return
		if number:
			new_guest.number = number
		else:
			self.response.status = 404
			self.response.status_message = "Invalid request: must specify number in party"
			return
		if food:
			new_guest.food = food
		if email:
			new_guest.email = email
		
		key = new_guest.put()
		out = new_guest.to_dict()
		self.response.write(json.dumps(out))
		return

	def get(self, **kwargs):
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not acceptable, API only supports json"
			return
		if 'id' in kwargs:
			out = ndb.Key(db_defs.Guest, int(kwargs['id'])).get()
			if not out:
				self.response.status = 404
				self.response.status_message = "RSVP not found"
				return
			self.response.write(json.dumps(out.to_dict()))
		else:
			q = db_defs.Guest.query()
			guests = q.fetch(keys_only=True)
			results = {'guest': [x.id() for x in guests]}
			self.response.write(json.dumps(results))


class Delete(webapp2.RequestHandler):
	def delete(self, **kwargs):
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not acceptable, API only supports json"
			return
		if 'id' in kwargs:
			rsvp_key = ndb.Key(db_defs.Guest, int(kwargs['id']))
			rsvp = rsvp_key.get()
			if not rsvp:
				self.response.status = 404
				self.response.status_message = "RSVP not found"
				return

			events = db_defs.Event.query().fetch()
		
			for event in events:
				if rsvp_key in event.guests:
					event.guests.remove(rsvp_key)	
					event.put()

			rsvp.key.delete()