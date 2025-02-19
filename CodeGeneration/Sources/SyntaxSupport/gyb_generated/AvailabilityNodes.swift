//// Automatically Generated From AvailabilityNodes.swift.gyb.
//// Do Not Edit Directly!
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

public let AVAILABILITY_NODES: [Node] = [
  Node(name: "AvailabilitySpecList",
       nameForDiagnostics: "'@availability' arguments",
       kind: "SyntaxCollection",
       element: "AvailabilityArgument"),

  Node(name: "AvailabilityArgument",
       nameForDiagnostics: "availability argument",
       description: "A single argument to an `@available` argument like `*`, `iOS 10.1`, or `message: \"This has been deprecated\"`.",
       kind: "Syntax",
       children: [
         Child(name: "Entry",
               kind: .nodeChoices(choices: [
                 Child(name: "Token",
                       kind: .token(choices: [.token(tokenKind: "BinaryOperatorToken"), .token(tokenKind: "IdentifierToken")], requiresLeadingSpace: false, requiresTrailingSpace: false)),
                 Child(name: "AvailabilityVersionRestriction",
                       kind: .node(kind: "AvailabilityVersionRestriction")),
                 Child(name: "AvailabilityLabeledArgument",
                       kind: .node(kind: "AvailabilityLabeledArgument"))
               ]),
               description: "The actual argument"),
         Child(name: "TrailingComma",
               kind: .token(choices: [.token(tokenKind: "CommaToken")]),
               description: "A trailing comma if the argument is followed by another argument",
               isOptional: true)
       ]),

  Node(name: "AvailabilityLabeledArgument",
       nameForDiagnostics: "availability argument",
       description: "A argument to an `@available` attribute that consists of a label and a value, e.g. `message: \"This has been deprecated\"`.",
       kind: "Syntax",
       children: [
         Child(name: "Label",
               kind: .token(choices: [.keyword(text: "message"), .keyword(text: "renamed"), .keyword(text: "introduced"), .keyword(text: "obsoleted"), .keyword(text: "deprecated")]),
               description: "The label of the argument"),
         Child(name: "Colon",
               kind: .token(choices: [.token(tokenKind: "ColonToken")]),
               description: "The colon separating label and value"),
         Child(name: "Value",
               kind: .nodeChoices(choices: [
                 Child(name: "String",
                       kind: .node(kind: "StringLiteralExpr")),
                 Child(name: "Version",
                       kind: .node(kind: "VersionTuple"))
               ]),
               description: "The value of this labeled argument")
       ]),

  Node(name: "AvailabilityVersionRestriction",
       nameForDiagnostics: "version restriction",
       description: "An argument to `@available` that restricts the availability on a certain platform to a version, e.g. `iOS 10` or `swift 3.4`.",
       kind: "Syntax",
       children: [
         Child(name: "Platform",
               kind: .token(choices: [.token(tokenKind: "IdentifierToken")]),
               description: "The name of the OS on which the availability should be restricted or 'swift' if the availability should be restricted based on a Swift version.",
               classification: "Keyword"),
         Child(name: "Version",
               kind: .node(kind: "VersionTuple"),
               isOptional: true)
       ]),

  Node(name: "VersionTuple",
       nameForDiagnostics: "version tuple",
       description: "A version number of the form major.minor.patch in which the minor and patch part may be omitted.",
       kind: "Syntax",
       children: [
         Child(name: "MajorMinor",
               kind: .token(choices: [.token(tokenKind: "IntegerLiteralToken"), .token(tokenKind: "FloatingLiteralToken")]),
               description: "In case the version consists only of the major version, an integer literal that specifies the major version. In case the version consists of major and minor version number, a floating literal in which the decimal part is interpreted as the minor version."),
         Child(name: "PatchPeriod",
               kind: .token(choices: [.token(tokenKind: "PeriodToken")]),
               description: "If the version contains a patch number, the period separating the minor from the patch number.",
               isOptional: true),
         Child(name: "PatchVersion",
               kind: .token(choices: [.token(tokenKind: "IntegerLiteralToken")]),
               description: "The patch version if specified.",
               isOptional: true)
       ]),

]
