import 'package:test/test.dart';
import 'package:notustohtml/notustohtml.dart';
import 'package:notus/notus.dart';

void main() {
  final converter = NotusHtmlCodec();

  group('Basic text', () {
    test("Plain paragraph", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {"insert": "Hello World!\n"}
      ]);

      expect(converter.encode(doc.toDelta()), "Hello World!<br><br>");
    });

    test("Bold paragraph", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {
          "insert": "Hello World!\n",
          "attributes": {"b": true}
        }
      ]);

      expect(converter.encode(doc.toDelta()), "<strong>Hello World!</strong><br><br>");
    });

    test("Italic paragraph", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {
          "insert": "Hello World!\n",
          "attributes": {"i": true}
        }
      ]);

      expect(converter.encode(doc.toDelta()), "<em>Hello World!</em><br><br>");
    });

    test("Bold and Italic paragraph", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {
          "insert": "Hello World!\n",
          "attributes": {"i": true, "b": true}
        }
      ]);

      expect(converter.encode(doc.toDelta()),
          "<em><strong>Hello World!</em></strong><br><br>");
    });
  });

  group('Headings', () {
    test("1", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {"insert": "Hello World!"},
        {
          "insert": "\n",
          "attributes": {"heading": 1}
        }
      ]);

      expect(converter.encode(doc.toDelta()), "<h1>Hello World!</h1><br><br>");
    });

    test("2", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {"insert": "Hello World!"},
        {
          "insert": "\n",
          "attributes": {"heading": 2}
        }
      ]);

      expect(converter.encode(doc.toDelta()), "<h2>Hello World!</h2><br><br>");
    });

    test("3", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {"insert": "Hello World!"},
        {
          "insert": "\n",
          "attributes": {"heading": 3}
        }
      ]);

      expect(converter.encode(doc.toDelta()), "<h3>Hello World!</h3><br><br>");
    });

    test("In list", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {"insert": "Hello World!"},
        {
          "insert": "\n",
          "attributes": {"block": "ul", "heading": 1},
        }
      ]);

      expect(converter.encode(doc.toDelta()),
          "<ul><li><h1>Hello World!</h1></li></ul><br><br>");
    });
  });

  group('Blocks', () {
    test("Quote", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {"insert": "Hello World!"},
        {
          "insert": "\n",
          "attributes": {"block": "quote"}
        }
      ]);

      expect(
          converter.encode(doc.toDelta()), "<blockquote>Hello World!</blockquote><br><br>");
    });
    test("Code", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {"insert": "Hello World!"},
        {
          "insert": "\n",
          "attributes": {"block": "code"}
        }
      ]);

      expect(converter.encode(doc.toDelta()), "<br><code>Hello World!</code><br><br><br>");
    });
    test("Ordered list", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {"insert": "Hello World!"},
        {
          "insert": "\n",
          "attributes": {"block": "ol"}
        }
      ]);

      expect(converter.encode(doc.toDelta()), "<ol><li>Hello World!</li></ol><br><br>");
    });
    test("List with bold", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {
          "insert": "Hello World!",
          "attributes": {"b": true}
        },
        {
          "insert": "\n",
          "attributes": {"block": "ol"}
        }
      ]);

      expect(converter.encode(doc.toDelta()), "<ol><li><strong>Hello World!</strong></li></ol><br><br>");
    });
    test("Unordered list", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {"insert": "Hello World!"},
        {
          "insert": "\n",
          "attributes": {"block": "ul"}
        },
        {"insert": "Hello World!"},
        {
          "insert": "\n",
          "attributes": {"block": "ul"}
        }
      ]);

      expect(converter.encode(doc.toDelta()), "<ul><li>Hello World!</li><li>Hello World!</li></ul><br><br>");
    });
  });

  group('Embeds', () {
    test("Image", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {
          "insert": "",
          "attributes": {
            "embed": {
              "type": "image",
              "source": "http://fake.link/image.png",
            },
          },
        },
        {"insert": "\n"}
      ]);

      expect(converter.encode(doc.toDelta()),
          "<img src=\"http://fake.link/image.png\"><br><br>");
    });
    test("Line", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {
          "insert": "",
          "attributes": {
            "embed": {
              "type": "hr",
            },
          },
        },
        {"insert": "\n"}
      ]);

      expect(converter.encode(doc.toDelta()), "<hr><br><br>");
    });
  });

  group('Links', () {
    test("Plain", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {
          "insert": "Hello World!",
          "attributes": {"a": "http://fake.link"},
        },
        {"insert": "\n"}
      ]);

      expect(converter.encode(doc.toDelta()),
          "<a href=\"http://fake.link\">Hello World!</a><br><br>");
    });

    test("Italic", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {
          "insert": "Hello World!",
          "attributes": {"a": "http://fake.link", "i": true},
        },
        {"insert": "\n"}
      ]);

      expect(converter.encode(doc.toDelta()),
          "<a href=\"http://fake.link\"><em>Hello World!</em></a><br><br>");
    });

    test("In list", () {
      final NotusDocument doc = NotusDocument.fromJson([
        {
          "insert": "Hello World!",
          "attributes": {"a": "http://fake.link"},
        },
        {
          "insert": "\n",
          "attributes": {"block": "ul"},
        }
      ]);

      expect(converter.encode(doc.toDelta()),
          "<ul><li><a href=\"http://fake.link\">Hello World!</a></li></ul><br><br>");
    });
  });
}
