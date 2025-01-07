import Testing
import Foundation
@testable import AnyCodable

struct AnyDecodableTests {
    @Test
    func jsonDecoding() throws {
        let json = try #require("""
        {
            "boolean": true,
            "integer": 42,
            "double": 3.141592653589793,
            "string": "string",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            },
            "null": null
        }
        """.data(using: .utf8))

        let decoder = JSONDecoder()
        let dictionary = try decoder.decode([String: AnyDecodable].self, from: json)

        #expect(dictionary["boolean"]?.value as? Bool == true)
        #expect(dictionary["integer"]?.value as? Int == 42)
        #expect(dictionary["double"]?.value as? Double == 3.141592653589793)
        #expect(dictionary["string"]?.value as? String == "string")
        #expect(dictionary["array"]?.value as? [Int] == [1, 2, 3])
        #expect(dictionary["nested"]?.value as? [String: String] == ["a": "alpha", "b": "bravo", "c": "charlie"])
        #expect(dictionary["null"]?.value as? NSNull == NSNull())
    }
}
