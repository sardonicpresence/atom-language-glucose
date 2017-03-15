module.exports =
  provideLinter: ->
    name: 'glucose'
    scope: 'file'
    lintsOnChange: true
    grammarScopes: ['source.glucose']
    lint: (editor) ->
      console.log "Linting " + editor.getPath()
      new Promise (resolve) -> resolve [
        severity: 'error'
        location:
          file: editor.getPath()
          position: [[3, 0], [3, 3]]
        excerpt: 'An error'
        description: 'It\'s just a fake error okay?'
      ,
        severity: 'warning'
        location:
          file: editor.getPath()
          position: [[13, 5], [13, 10]]
        excerpt: 'A warning'
        description: 'It\'s just a fake warning okay?'
      ]
