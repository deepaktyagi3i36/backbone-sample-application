TestProject.Views.Persons ||= {}

class TestProject.Views.Persons.IndexView extends Backbone.View
  template: JST["backbone/templates/persons/index"]
  BULK_UPLOAD_URL = '/persons/bulk_upload'

  events:
    "submit #upload-person": "save"
    'change input[type=file]': 'uploadFile'

  initialize: () ->
    @collection.bind('reset', @addAll)
    @model = new @collection.model()

  uploadFile: (e) ->
    fileObj = e.target.files[0]
    reader = new FileReader
    self = @
    
    reader.onload = (file) ->
      self.model.set('person_data', reader.result)

    reader.readAsText fileObj

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    self = @
    
    @collection.create(@model.toJSON(),
      url: BULK_UPLOAD_URL
      success: (persons) =>
        persons.changed.person_data.forEach (person) ->
          model = new self.collection.model()
          model.set(person)
          self.addOne(model)
    )

  addAll: () =>
    @collection.each(@addOne)

  addOne: (person) =>
    view = new TestProject.Views.Persons.PersonView({model : person})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(persons: @collection.toJSON() ))
    @$("form").backboneLink(@model)
    @addAll()
    return @