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
    @subscriptions.add atom.config.observe 'norminette-linter.executablePath',
      (executablePath) => @executablePath = executablePath

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
        # # /Users/crenault/Desktop/norminette
        helpers.exec(@executablePath, parameters).then (out) ->
          helpers.parse(out, regex, filePath: textEditor.getPath()).map (err) ->
            err.type = 'Error'
            err
