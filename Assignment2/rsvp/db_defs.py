from google.appengine.ext import ndb

#database definitions, subclasses of ndb.Model
class Message(ndb.Model):
	name = ndb.StringProperty(required=True)

class RSVP(ndb.Model):
	name = ndb.StringProperty(required=True)
	answer = ndb.BooleanProperty(required=True)
	number = ndb.IntegerProperty(required=True)
	events = ndb.KeyProperty(repeated=True)
	food = ndb.StringProperty(required=False)
	email = ndb.StringProperty(required=False)

class Event(ndb.Model):
	name = ndb.StringProperty(required=True)
	checked = ndb.BooleanProperty(required=False)