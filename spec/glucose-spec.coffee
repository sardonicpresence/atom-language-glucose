fs = require 'fs'
path = require 'path'

describe "Glucose grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-glucose")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.glucose")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.glucose"

  it "tokenizes global constant definitions", ->
    tokens = grammar.tokenizeLines("_\u05d0a3 \n\u00a0=\n 12.3e-02")

    expect(tokens[0][0]).toEqual value: "_\u05d0a3", scopes: ["source.glucose", "meta.definition.glucose", "entity.name.function.glucose"]
    expect(tokens[1][1]).toEqual value: "=", scopes: ["source.glucose", "meta.definition.glucose", "keyword.operator.definition.glucose"]
    expect(tokens[2][1]).toEqual value: "12.3e-02", scopes: ["source.glucose", "constant.numeric.float.glucose"]

  it "tokenizes function definitions", ->
    tokens = grammar.tokenizeLines("const \n\u00a0= \n \\  a \n b ->\n a ")

    expect(tokens[0][0]).toEqual value: "const", scopes: ["source.glucose", "meta.definition.glucose", "entity.name.function.glucose"]
    expect(tokens[1][1]).toEqual value: "=", scopes: ["source.glucose", "meta.definition.glucose", "keyword.operator.definition.glucose"]
    expect(tokens[2][1]).toEqual value: "\\", scopes: ["source.glucose", "meta.lambda.glucose", "keyword.operator.lambda.glucose"]
    expect(tokens[2][3]).toEqual value: "a", scopes: ["source.glucose", "meta.lambda.glucose", "variable.parameter.glucose"]
    expect(tokens[3][1]).toEqual value: "b", scopes: ["source.glucose", "meta.lambda.glucose", "variable.parameter.glucose"]
    expect(tokens[3][3]).toEqual value: "->", scopes: ["source.glucose", "meta.lambda.glucose", "keyword.operator.arrow.glucose"]
    expect(tokens[4][1]).toEqual value: "a", scopes: ["source.glucose", "variable.glucose"]
