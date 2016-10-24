#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
import webapp2
from google.appengine.api import oauth

app = webapp2.WSGIApplication([
	('/rsvp', 'rsvp.RSVP'),
	('/event', 'event.Event'),
], debug=True)
app.router.add(webapp2.Route(r'/rsvp/<id:[0-9]+><:/?>', 'rsvp.RSVP'))
app.router.add(webapp2.Route(r'/event/<id:[0-9]+><:/?>', 'event.Event'))
app.router.add(webapp2.Route(r'/event/<eid:[0-9]+>/rsvp/<rid:[0-9]+><:/?>', 'event.EventRSVP'))
app.router.add(webapp2.Route(r'/event/delete/<id:[0-9]+><:/?>', 'event.Delete'))
app.router.add(webapp2.Route(r'/rsvp/delete/<id:[0-9]+><:/?>', 'rsvp.Delete'))