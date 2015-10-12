from google.appengine.ext import ndb

#database definitions, subclasses of ndb.Model
class Message(ndb.Model):
	name = ndb.StringProperty(required=True)

class RSVP(ndb.Model):
	name = ndb.StringProperty(required=True)
	answer = ndb.BooleanProperty(required=True)
	number = ndb.IntegerProperty(required=True)
	foods = ndb.StringProperty(repeated=True)
	email = ndb.StringProperty(required=False)

class Foods(ndb.Model):
	name = ndb.StringProperty(required=True)