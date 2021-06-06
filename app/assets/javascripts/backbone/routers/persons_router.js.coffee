class TestProject.Routers.PersonsRouter extends Backbone.Router
  initialize: (options) ->
    @persons = new TestProject.Collections.PersonsCollection()
    @persons.reset options.persons

  routes:
    "index"    : "index"
    ".*"        : "index"

  index: ->
    @view = new TestProject.Views.Persons.IndexView(collection: @persons)
    $("#persons").html(@view.render().el)