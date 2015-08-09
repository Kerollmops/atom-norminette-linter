{CompositeDisposable} = require "atom"

module.exports = NorminetteLinter =

  config:
    executablePath:
      type: 'string'
      default: 'norminette'
      description: 'The executable path to the 42 norminette.'

  activate: (state) ->
    if !atom.packages.getLoadedPackages("linter")
      atom.notifications.addError(
        "Linter package not found.",
        { detail: "Please install the `linter` package in your Settings view." }
      )
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'norminette-linter.executablePath', (executablePath) =>
        @executablePath = executablePath

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    helpers = require 'atom-linter'
    regex = \
    "^Error\\s*\\(?" +
    "(?:\\s*line\\s*(?<line>[0-9]+))?" +  # get line
    "\\s*,?" +
    "(?:\\s*col\\s*(?<col>[0-9]+))?" +    # get column
    "\\s*\\)?" +
    ":\\s*(?<message>.+)$"                # get message
    provider =
      grammarScopes: ['source.c', 'source.h']
      scope: 'file'
      lintOnFly: false
      lint: (textEditor) =>
        parameters = [textEditor.getPath()]
        # message = {
        #   type: 'Error',
        #   text: 'Something went wrong',
        #   filePath: textEditor.getPath(),
        #   range: [[0,0], [0,5]]
        # }
        # # /Users/crenault/Desktop/norminette
        return helpers.exec(@executablePath, parameters).then (output) ->
          return helpers.parse(output, regex, filePath: textEditor.getPath()).map (error) ->
            error.type = 'Error'
            return error
