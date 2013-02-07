RootView = require 'root-view'

describe 'GoToLine', ->
  [rootView, goToLine, editor] = []

  beforeEach ->
    rootView = new RootView(require.resolve('fixtures/sample.js'))
    rootView.enableKeymap()
    atom.loadPackage("go-to-line")
    editor = rootView.getActiveEditor()
    editor.trigger 'editor:go-to-line'
    goToLine = rootView.find('.go-to-line').view()
    editor.trigger 'editor:go-to-line'
    editor.setCursorBufferPosition([1,0])

  afterEach ->
    rootView.remove()

  describe "when editor:go-to-line is triggered", ->
    it "attaches to the root view", ->
      expect(goToLine.hasParent()).toBeFalsy()
      editor.trigger 'editor:go-to-line'
      expect(goToLine.hasParent()).toBeTruthy()

  describe "when entering a line number", ->
    it "only allows 0-9 to be entered in the mini editor", ->
      expect(goToLine.miniEditor.getText()).toBe ''
      goToLine.miniEditor.textInput 'a'
      expect(goToLine.miniEditor.getText()).toBe ''
      goToLine.miniEditor.textInput '40'
      expect(goToLine.miniEditor.getText()).toBe '40'

  describe "when core:confirm is triggered", ->
    describe "when a line number has been entered", ->
      it "moves the cursor to the first character of the line", ->
        goToLine.miniEditor.textInput '3'
        goToLine.miniEditor.trigger 'core:confirm'
        expect(editor.getCursorBufferPosition()).toEqual [2, 4]

    describe "when no line number has been entered", ->
      it "closes the view and does not update the cursor position", ->
        editor.trigger 'editor:go-to-line'
        expect(goToLine.hasParent()).toBeTruthy()
        goToLine.miniEditor.trigger 'core:confirm'
        expect(goToLine.hasParent()).toBeFalsy()
        expect(editor.getCursorBufferPosition()).toEqual [1, 0]

  describe "when core:cancel is triggered", ->
    it "closes the view and does not update the cursor position", ->
      editor.trigger 'editor:go-to-line'
      expect(goToLine.hasParent()).toBeTruthy()
      goToLine.miniEditor.trigger 'core:cancel'
      expect(goToLine.hasParent()).toBeFalsy()
      expect(editor.getCursorBufferPosition()).toEqual [1, 0]
