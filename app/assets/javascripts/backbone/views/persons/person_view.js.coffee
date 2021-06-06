TestProject.Views.Persons ||= {}

class TestProject.Views.Persons.PersonView extends Backbone.View
  template: JST["backbone/templates/persons/person"]
  URL = '/persons/'

  events:
    "change input[type=text]" : "onInput"
    "submit .error-person": "reSave"

  tagName: "tr"

  onInput: (e) ->
    @model.set(e.target.name, e.target.value)

  reSave: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @resetErrors()
    self = @    

    @model.save(@model.toJSON(),
      url: URL
      method: 'POST'
      success: (person) =>
        self.model = person        
        self.$el.html(self.template(self.model.toJSON()))
      error: (person, jqXHR) =>
        self.model.set($.parseJSON(jqXHR.responseText))
        self.$el.html(self.template(self.model.toJSON()))
    )

  resetErrors: ->
    @model.unset('has_error')
    @model.unset('error_message')
    @model.unset('person_data')

  render: ->
    @$el.html(@template(@model.toJSON()))
    return @
