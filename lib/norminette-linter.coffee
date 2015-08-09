{CompositeDisposable} = require "atom"

module.exports = NorminetteLinter =

  activate: (state) ->
    if !atom.packages.getLoadedPackages("linter")
      atom.notifications.addError(
        "Linter package not found.",
        { detail: "Please install the `linter` package in your Settings view." }
      )

  provideLinter: ->
    helpers = require 'atom-linter'
    console.log "norminette provideLinter"
    # regex = "^Error\s*\(?(?:\s*line\s*([0-9]+))?\s*,?(?:\s*col\s*([0-9]+))?\s*\)?:\s*(.+)$"
    return {
      grammarScopes: ['source.c', 'source.h']
      scope: 'file'
      lintOnFly: true
      lint: (textEditor)->
        parameters = []
        message = {
          type: 'Error',
          text: 'Something went wrong',
          filePath: textEditor.getPath(),
          range: [[0,0], [0,5]]
        }
        [message]
    }
