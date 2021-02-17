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
    let abc: String
    let fooValue: String?
    let fooPrepaid: Bool?

    enum CodingKeys: String, CodingKey {
        case abc
        case foo
    }

    enum fooKeys: String, CodingKey {
        case value
        case prepaid
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        abc = try values.decode(String.self, forKey: .abc)

        let nestedFoo = try values.nestedContainer(keyedBy: fooKeys.self, forKey: .foo)
        fooValue = try nestedFoo.decode(String.self, forKey: .value)
        fooPrepaid = try nestedFoo.decode(Bool.self, forKey: .prepaid)
    }
}

guard let j = try? JSONDecoder().decode(Json.self, from: json.data(using: .utf8)!) else { fatalError("Invalid json") }

debugPrint(j)

let diff = CFAbsoluteTimeGetCurrent() - start
print("Took \(diff) seconds")
