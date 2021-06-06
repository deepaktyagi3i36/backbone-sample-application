class TestProject.Models.Person extends Backbone.Model
  paramRoot: 'person'

  defaults:
    first_name: null
    last_name: null
    email: null
    phone: null
    person_data: null
    has_error: false
    error_message: null


class TestProject.Collections.PersonsCollection extends Backbone.Collection
  model: TestProject.Models.Person
  url: '/persons'