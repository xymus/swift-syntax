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

// This test file has been translated from swift/test/Parse/multiline_errors.swift

import XCTest

import SwiftSyntax

func AssertParseWithAllNewlineEndings(
  _ markedSource: String,
  substructure expectedSubstructure: Syntax? = nil,
  substructureAfterMarker: String = "START",
  diagnostics expectedDiagnostics: [DiagnosticSpec] = [],
  applyFixIts: [String]? = nil,
  fixedSource expectedFixedSource: String? = nil,
  file: StaticString = #file,
  line: UInt = #line
) {
  for newline in ["\n", "\r", "\r\n"] {
    AssertParse(
      markedSource.replacingOccurrences(of: "\n", with: newline),
      substructure: expectedSubstructure,
      substructureAfterMarker: substructureAfterMarker,
      diagnostics: expectedDiagnostics,
      applyFixIts: applyFixIts,
      fixedSource: expectedFixedSource,
      options: [.normalizeNewlinesInFixedSource],
      file: file,
      line: line
    )
  }
}

final class MultilineErrorsTests: XCTestCase {
  func testMultilineErrors1() {
    AssertParseWithAllNewlineEndings(
      """
      import Swift
      """
    )
  }

  func testMultilineErrors2() {
    AssertParseWithAllNewlineEndings(
      """
      // ===---------- Multiline --------===
      """
    )
  }

  func testMultilineErrors3() {
    // expecting at least 4 columns of leading indentation
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
          Eleven
        1️⃣Mu
          ℹ️"""
      """#,
      diagnostics: [
        DiagnosticSpec(
          message: "insufficient indentation of line in multi-line string literal",
          notes: [NoteSpec(message: "should match indentation here")],
          fixIts: ["change indentation of this line to match closing delimiter"]
        )
      ],
      fixedSource: #"""
        _ = """
            Eleven
            Mu
            """
        """#
    )
  }

  func testMultilineErrors4() {
    // expecting at least 4 columns of leading indentation
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
          Eleven
         1️⃣Mu
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            Eleven
            Mu
            """
        """#
    )
  }

  func testMultilineErrors5() {
    // \t is not the same as an actual tab
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
      	Twelve
      1️⃣\tNu
      	"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
        	Twelve
        	\tNu
        	"""
        """#
    )
  }

  func testMultilineErrors6a() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
          \(42
      1️⃣)
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            \(42
            )
            """
        """#
    )
  }

  func testMultilineErrors6b() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
          \(42
       1️⃣)
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            \(42
            )
            """
        """#
    )
  }

  func testMultilineErrors7() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
          Foo
      1️⃣\
          Bar 
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            Foo
            \
            Bar
            """
        """#
    )
  }

  func testMultilineErrors8() {
    // a tab is not the same as multiple spaces
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
        Thirteen
      1️⃣	Xi
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "unexpected tab in indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
          Thirteen
          Xi
          """
        """#
    )
  }

  func testMultilineErrors9() {
    // a tab is not the same as multiple spaces
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
          Fourteen
        1️⃣	Pi
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "unexpected tab in indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            Fourteen
            Pi
            """
        """#
    )
  }

  func testMultilineErrors10() {
    // multiple spaces are not the same as a tab
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
      	Thirteen 2
      1️⃣  Xi 2
      	"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "unexpected space in indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
        	Thirteen 2
        	Xi 2
        	"""
        """#
    )
  }

  func testMultilineErrors11() {
    // multiple spaces are not the same as a tab
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
      		Fourteen 2
      	1️⃣  Pi 2
      		"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "unexpected space in indentation of line in multi-line string literal")
      ]
    )
  }

  func testMultilineErrors12() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """1️⃣Fourteen
          Pi
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal content must begin on a new line", fixIts: ["insert newline"])
      ],
      fixedSource: #"""
        _ = """
            Fourteen
            Pi
            """
        """#
    )
  }

  func testMultilineErrors13() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
          Fourteen
          Pi1️⃣"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal closing delimiter must begin on a new line")
      ],
      fixedSource: #"""
        _ = """
            Fourteen
            Pi
            """
        """#
    )
  }

  func testMultilineErrors14() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """1️⃣"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal closing delimiter must begin on a new line", fixIts: ["insert newline"])
      ],
      fixedSource: #"""
        _ = """
        """
        """#
    )
  }

  func testMultilineErrors15() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """ 1️⃣"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal closing delimiter must begin on a new line", fixIts: ["insert newline"])
      ],
      fixedSource: #"""
        _ = """
        """
        """#
    )
  }

  func testMultilineErrors16() {
    // two lines should get only one error
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
      1️⃣    Hello,
              World!
      	"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "unexpected space in indentation of the next 2 lines in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
        	Hello,
        	World!
        	"""
        """#
    )
  }

  func testMultilineErrors17a() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
      1️⃣Zero A
      Zero B
      	One A
      	One B
      2️⃣  Two A
        Two B
      3️⃣Three A
      Three B
      		Four A
      		Four B
      			Five A
      			Five B
      		"""
      """#,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: "insufficient indentation of the next 4 lines in multi-line string literal"),
        DiagnosticSpec(locationMarker: "2️⃣", message: "unexpected space in indentation of the next 2 lines in multi-line string literal"),
        DiagnosticSpec(locationMarker: "3️⃣", message: "insufficient indentation of the next 2 lines in multi-line string literal"),
      ],
      fixedSource: #"""
        _ = """
        		Zero A
        		Zero B
        		One A
        		One B
        		Two A
        		Two B
        		Three A
        		Three B
        		Four A
        		Four B
        			Five A
        			Five B
        		"""
        """#
    )
  }

  func testMultilineErrors17b() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
      1️⃣Zero A\(1)B
      Zero B
            X
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of the next 2 lines in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            Zero A\(1)B
            Zero B
              X
            """
        """#
    )
  }

  func testMultilineErrors17c() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
      1️⃣Incorrect 1
          Correct
      2️⃣Incorrect 2
          """
      """#,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: "insufficient indentation of line in multi-line string literal"),
        DiagnosticSpec(locationMarker: "2️⃣", message: "insufficient indentation of line in multi-line string literal"),
      ],
      fixedSource: #"""
        _ = """
            Incorrect 1
            Correct
            Incorrect 2
            """
        """#
    )
  }

  func testMultilineErrors18() {
    AssertParseWithAllNewlineEndings(
      ##"""
      _ = "hello\("""
                  world
                  """1️⃣
                  2️⃣)!"
      """##,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: "expected ')' in string literal"),
        DiagnosticSpec(locationMarker: "1️⃣", message: #"expected '"' to end string literal"#),
        DiagnosticSpec(locationMarker: "2️⃣", message: #"extraneous code ')!"' at top level"#),
      ]
    )
  }

  func testMultilineErrors19() {
    AssertParseWithAllNewlineEndings(
      ##"""
      _ = "h\(1️⃣
                  """
                  world
                  """2️⃣)!"
      """##,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: "expected value and ')' in string literal"),
        DiagnosticSpec(locationMarker: "1️⃣", message: #"expected '"' to end string literal"#),
        DiagnosticSpec(locationMarker: "2️⃣", message: #"extraneous code ')!"' at top level"#),
      ]
    )
  }

  func testMultilineErrors20() {
    AssertParseWithAllNewlineEndings(
      ##"""
      _ = """
        line one 1️⃣\ non-whitespace
        line two
        """
      """##,
      diagnostics: [
        DiagnosticSpec(message: "invalid escape sequence in literal")
      ]
    )
  }

  func testMultilineErrors21() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
        line one
        line two1️⃣\
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "escaped newline at the last line of a multi-line string literal is not allowed", fixIts: ["remove '\'"])
      ],
      fixedSource: #"""
        _ = """
          line one
          line two
          """
        """#
    )
  }

  func testMultilineErrors22() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
        \\1️⃣\	   
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "escaped newline at the last line of a multi-line string literal is not allowed")
      ],
      fixedSource: #"""
        _ = """
          \\
          """
        """#
    )
  }

  func testMultilineErrors23() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
        \(42)1️⃣\		
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "escaped newline at the last line of a multi-line string literal is not allowed")
      ],
      fixedSource: #"""
        _ = """
          \(42)
          """
        """#
    )
  }

  func testMultilineErrors24() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
        foo1️⃣\
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "escaped newline at the last line of a multi-line string literal is not allowed")
      ],
      fixedSource: #"""
        _ = """
          foo
          """
        """#
    )
  }

  func testMultilineErrors25() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
        foo1️⃣\
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "escaped newline at the last line of a multi-line string literal is not allowed")
      ],
      fixedSource: #"""
        _ = """
          foo
          """
        """#
    )
  }

  func testMultilineErrors26() {
    AssertParseWithAllNewlineEndings(
      ##"""
      _ = """
        foo1️⃣\2️⃣
      """##,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: "invalid escape sequence in literal"),
        DiagnosticSpec(locationMarker: "2️⃣", message: #"expected '"""' to end string literal"#),
      ]
    )
  }

  func testMultilineErrors28() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
      1️⃣\
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "escaped newline at the last line of a multi-line string literal is not allowed")
      ],
      fixedSource: #"""
        _ = """
          
          """
        """#
    )
  }

  func testMultilineErrors29() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """1️⃣\
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal content must begin on a new line"),
        DiagnosticSpec(message: "escaped newline at the last line of a multi-line string literal is not allowed"),
      ],
      fixedSource: #"""
        _ = """
          
          """
        """#
    )
  }

  func testMultilineErrors30() {
    AssertParseWithAllNewlineEndings(
      ##"""
      let _ = """
        foo
        \ℹ️("bar1️⃣
        2️⃣baz3️⃣
        """
      """##,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: #"expected '"' to end string literal"#),
        DiagnosticSpec(locationMarker: "2️⃣", message: #"unexpected code 'baz' in string literal"#),
        DiagnosticSpec(locationMarker: "3️⃣", message: #"expected ')' in string literal"#, notes: [NoteSpec(message: "to match this opening '('")]),
      ],
      fixedSource: ##"""
        let _ = """
          foo
          \("bar"
          baz)
          """
        """##
    )
  }

  func testMultilineErrors31() {
    AssertParseWithAllNewlineEndings(
      ##"""
      let _ = """
        foo
        \ℹ️("bar1️⃣
        2️⃣baz3️⃣
        """
        abc
      """##,
      substructure: Syntax(IdentifierExprSyntax(identifier: .identifier("abc"))),
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: #"expected '"' to end string literal"#),
        DiagnosticSpec(locationMarker: "2️⃣", message: #"unexpected code 'baz' in string literal"#),
        DiagnosticSpec(locationMarker: "3️⃣", message: #"expected ')' in string literal"#, notes: [NoteSpec(message: "to match this opening '('")]),
      ]
    )
  }

  func testMultilineEndsWithStringInterpolation() {
    AssertParseWithAllNewlineEndings(
      #"""
      _ = """
      \(1)1️⃣"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal closing delimiter must begin on a new line")
      ],
      fixedSource: #"""
        _ = """
        \(1)
        """
        """#
    )
  }

  func testInsufficientIndentationInInterpolation() {
    AssertParseWithAllNewlineEndings(
      #"""
        """
        \(
      1️⃣1
        )
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
          """
          \(
          1
          )
          """
        """#
    )

    AssertParseWithAllNewlineEndings(
      #"""
        """
        \(
      1️⃣1
        +
      2️⃣2
        )
        """
      """#,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: "insufficient indentation of line in multi-line string literal"),
        DiagnosticSpec(locationMarker: "2️⃣", message: "insufficient indentation of line in multi-line string literal"),
      ],
      fixedSource: #"""
          """
          \(
          1
          +
          2
          )
          """
        """#
    )

    AssertParseWithAllNewlineEndings(
      #"""
        """
        \(
      1️⃣1
      +
      2
        )
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of the next 3 lines in multi-line string literal")
      ],
      fixedSource: #"""
          """
          \(
          1
          +
          2
          )
          """
        """#
    )
  }

  func testWhitespaceAfterOpenQuote() {
    AssertParse(
      #"""
      """1️⃣\#(" ")
      """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal content must begin on a new line")
      ]
    )
  }
}
