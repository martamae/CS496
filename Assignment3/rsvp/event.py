import webapp2
from google.appengine.ext import ndb
import db_defs
import json

class Event(webapp2.RequestHandler):
	def post(self):
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not Acceptable, API only supports json"
			return

		new_event = db_defs.Event()
		name = self.request.get('name', default_value=None)
		host = self.request.get('host', default_value=None)
		hostEmail = self.request.get('hostEmail', default_value=None)
		foods = self.request.get_all('foods[]', default_value=None)
		guests = self.request.get_all('guests[]', default_value=None)

		if name:
			new_event.name = name
		else:
			self.response.status = 404
			self.response.status_message = "Invalid request: must specify event name"
			return
		if host:
			new_event.host = host
		else:
			self.response.status = 404
			self.response.status_message = "Invalid request: must specify host's name"
			return
		if hostEmail:
			new_event.hostEmail = hostEmail
		if guests:
			for guest in guests:
				new_event.guests.append(ndb.Key(db_defs.Guest, int(guest)))
		if foods:
			new_event.foods = foods
		for foods in new_event.foods:
			print foods

		key = new_event.put()
		out = new_event.to_dict()
		self.response.write(json.dumps(out))
		return
	
	def get(self, **kwargs):
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not acceptable, API only supports json"
			return
		if 'id' in kwargs:
			out = ndb.Key(db_defs.Event, int(kwargs['id'])).get()
			if not out:
				self.response.status = 404
				self.response.status_message = "Event not found"
				return
			self.response.write(json.dumps(out.to_dict()))
		else:
			q = db_defs.Event.query()
			events = q.fetch(keys_only=True)
			results = {'event': [x.id() for x in events]}
			self.response.write(json.dumps(results))

class EventRSVP(webapp2.RequestHandler):
	def put(self, **kwargs):
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not acceptable, API only supports json"
			return
		if 'eid' in kwargs:
			event = ndb.Key(db_defs.Event, int(kwargs['eid'])).get()
			if not event:
				self.response.status = 404
				self.response.status_message = "Event not found"
				return
		if 'rid' in kwargs:
			guest = ndb.Key(db_defs.Guest, int(kwargs['rid']))
			if not guest:
				self.response.status = 404
				self.response.status_message = "Guest not found"
				return
		if guest not in event.guests:
			event.guests.append(guest)
			event.put()
		self.response.write(json.dumps(event.to_dict()))
		return

class Delete(webapp2.RequestHandler):
	def delete(self, **kwargs):
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not acceptable, API only supports json"
			return
		if 'id' in kwargs:
			event_key = ndb.Key(db_defs.Event, int(kwargs['id']))
			event = event_key.get()
			if not event:
				self.response.status = 404
				self.response.status_message = "Event not found"
				return
		
			for guest_key in event.guests:
				guest = guest_key.get()
				guest.key.delete()

			event.key.delete()