import Foundation

let start = CFAbsoluteTimeGetCurrent()

let json = """
{
"abc": "abc",
"foo": {
  "value": "bar",
  "prepaid": true
}
}
"""

struct Json: Decodable {
    private struct Foo: Decodable {
        let value: String
        let prepaid: Bool
    }

    let abc: String

    // From Foo
    var fooValue: String { foo.value }
    var fooPrepaid: Bool { foo.prepaid }
    private let foo: Foo

    enum CodingKeys: String, CodingKey {
        case abc
        case foo
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        abc = try values.decode(String.self, forKey: .abc)
        foo = try values.decode(Foo.self, forKey: .foo)
    }
}

guard let j = try? JSONDecoder().decode(Json.self, from: json.data(using: .utf8)!) else { fatalError("Invalid json") }

debugPrint(j)

let diff = CFAbsoluteTimeGetCurrent() - start
print("Took \(diff) seconds")
