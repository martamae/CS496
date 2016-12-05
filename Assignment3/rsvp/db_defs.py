from google.appengine.ext import ndb

class Model(ndb.Model):
	def to_dict(self):
		d = super(Model,self).to_dict()
		d['key'] = self.key.id()
		return d

class Guest(Model):
	name = ndb.StringProperty(required=True)
	answer = ndb.BooleanProperty(required=True)
	number = ndb.IntegerProperty(required=True)
	food = ndb.StringProperty(required=False)
	email = ndb.StringProperty(required=False)

class Event(Model):
	name = ndb.StringProperty(required=True)
	un = ndb.StringProperty(required=True)
	host = ndb.StringProperty(required=True)
	hostEmail = ndb.StringProperty(required=False)
	address1 = ndb.StringProperty(required=True)
	address2 = ndb.StringProperty(required=False)
	city = ndb.StringProperty(required=True)
	state = ndb.StringProperty(required=True)
	zip = ndb.StringProperty(required=True)
	foods = ndb.StringProperty(repeated=True)
	guests = ndb.KeyProperty(repeated=True)

	def to_dict(self):
		d = super(Event, self).to_dict()
		d['guests'] = [g.id() for g in d['guests']]
		return d