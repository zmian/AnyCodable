import Testing
import Foundation
@testable import AnyCodable

struct AnyCodableTests {
    struct SomeCodable: Codable {
        var string: String
        var int: Int
        var bool: Bool
        var hasUnderscore: String
        
        enum CodingKeys: String,CodingKey {
            case string
            case int
            case bool
            case hasUnderscore = "has_underscore"
        }
    }

    @Test
    func jsonDecoding() throws {
        let json = try #require("""
        {
            "boolean": true,
            "booleanString": "true",
            "integer": 42,
            "double": 3.141592653589793,
            "string": "string",
            "stringInteger": "100",
            "stringDouble": "99.99",
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
        let dictionary = try decoder.decode([String: AnyCodable].self, from: json)

        #expect(dictionary["boolean"]?.value as? Bool == true)
        #expect(dictionary["integer"]?.value as? Int == 42)
        #expect(dictionary["double"]?.value as? Double == 3.141592653589793)
        #expect(dictionary["string"]?.value as? String == "string")
        #expect(dictionary["booleanString"]?.value as? String == "true")
        #expect(dictionary["stringInteger"]?.value as? String == "100")
        #expect(dictionary["stringDouble"]?.value as? String == "99.99")
        #expect(dictionary["array"]?.value as? [Int] == [1, 2, 3])
        #expect(dictionary["nested"]?.value as? [String: String] == ["a": "alpha", "b": "bravo", "c": "charlie"])
        #expect(dictionary["null"]?.value as? NSNull == NSNull())
    }

    @Test
    func jsonDecodingEquatable() throws {
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
        let dictionary1 = try decoder.decode([String: AnyCodable].self, from: json)
        let dictionary2 = try decoder.decode([String: AnyCodable].self, from: json)

        #expect(dictionary1["boolean"] == dictionary2["boolean"])
        #expect(dictionary1["integer"] == dictionary2["integer"])
        #expect(dictionary1["double"] == dictionary2["double"])
        #expect(dictionary1["string"] == dictionary2["string"])
        #expect(dictionary1["array"] == dictionary2["array"])
        #expect(dictionary1["nested"] == dictionary2["nested"])
        #expect(dictionary1["null"] == dictionary2["null"])
    }

    @Test
    func jsonEncoding() throws {
        let someCodable = AnyCodable(
            SomeCodable(
                string: "String",
                int: 100,
                bool: true,
                hasUnderscore: "another string"
            )
        )

        let injectedValue = 1234
        let dictionary: [String: AnyCodable] = [
            "boolean": true,
            "integer": 42,
            "double": 3.141592653589793,
            "string": "string",
            "stringInterpolation": "string \(injectedValue)",
            "array": [1, 2, 3],
            "nested": [
                "a": "alpha",
                "b": "bravo",
                "c": "charlie",
            ],
            "someCodable": someCodable,
            "null": nil
        ]

        let encoder = JSONEncoder()
        let json = try encoder.encode(dictionary)
        let encodedJSONObject = try #require(try JSONSerialization.jsonObject(with: json) as? NSDictionary)

        let expected = try #require("""
        {
            "boolean": true,
            "integer": 42,
            "double": 3.141592653589793,
            "string": "string",
            "stringInterpolation": "string 1234",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            },
            "someCodable": {
                "string":"String",
                "int":100,
                "bool": true,
                "has_underscore":"another string"
            },
            "null": null
        }
        """.data(using: .utf8))

        let expectedJSONObject = try #require(try JSONSerialization.jsonObject(with: expected) as? NSDictionary)
        #expect(encodedJSONObject == expectedJSONObject)
    }
}
