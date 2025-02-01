import Testing
import Foundation
@testable import AnyCodable

struct AnyEncodableTests {
    struct SomeEncodable: Encodable {
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
    func jsonEncoding() throws {
        let someEncodable = AnyEncodable(
            SomeEncodable(
                string: "String",
                int: 100,
                bool: true,
                hasUnderscore: "another string"
            )
        )

        let dictionary: [String: AnyEncodable] = [
            "boolean": true,
            "integer": 42,
            "double": 3.141592653589793,
            "string": "string",
            "array": [1, 2, 3],
            "nested": [
                "a": "alpha",
                "b": "bravo",
                "c": "charlie",
            ],
            "someCodable": someEncodable,
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

    @Test
    func encodeNSNumber() throws {
        let dictionary: [String: NSNumber] = [
            "boolean": true,
            "char": -127,
            "int": -32767,
            "short": -32767,
            "long": -2147483647,
            "longlong": -9223372036854775807,
            "uchar": 255,
            "uint": 65535,
            "ushort": 65535,
            "ulong": 4294967295,
            "ulonglong": 18446744073709615,
            "double": 3.141592653589793,
        ]

        let encoder = JSONEncoder()
        let json = try encoder.encode(AnyEncodable(dictionary))
        let encodedJSONObject = try #require(try JSONSerialization.jsonObject(with: json) as? NSDictionary)

        let expected = try #require("""
        {
            "boolean": true,
            "char": -127,
            "int": -32767,
            "short": -32767,
            "long": -2147483647,
            "longlong": -9223372036854775807,
            "uchar": 255,
            "uint": 65535,
            "ushort": 65535,
            "ulong": 4294967295,
            "ulonglong": 18446744073709615,
            "double": 3.141592653589793,
        }
        """.data(using: .utf8))

        let expectedJSONObject = try #require(try JSONSerialization.jsonObject(with: expected) as? NSDictionary)
        #expect(encodedJSONObject == expectedJSONObject)
        #expect(encodedJSONObject["boolean"] is Bool)

        #expect(encodedJSONObject["char"] is Int8)
        #expect(encodedJSONObject["int"] is Int16)
        #expect(encodedJSONObject["short"] is Int32)
        #expect(encodedJSONObject["long"] is Int32)
        #expect(encodedJSONObject["longlong"] is Int64)

        #expect(encodedJSONObject["uchar"] is UInt8)
        #expect(encodedJSONObject["uint"] is UInt16)
        #expect(encodedJSONObject["ushort"] is UInt32)
        #expect(encodedJSONObject["ulong"] is UInt32)
        #expect(encodedJSONObject["ulonglong"] is UInt64)

        #expect(encodedJSONObject["double"] is Double)
    }

    @Test
    func stringInterpolationEncoding() throws {
        let dictionary: [String: AnyEncodable] = [
            "boolean": "\(true)",
            "integer": "\(42)",
            "double": "\(3.141592653589793)",
            "string": "\("string")",
            "array": "\([1, 2, 3])",
        ]

        let encoder = JSONEncoder()
        let json = try encoder.encode(dictionary)
        let encodedJSONObject = try #require(try JSONSerialization.jsonObject(with: json) as? NSDictionary)

        let expected = try #require("""
        {
            "boolean": "true",
            "integer": "42",
            "double": "3.141592653589793",
            "string": "string",
            "array": "[1, 2, 3]",
        }
        """.data(using: .utf8))

        let expectedJSONObject = try #require(try JSONSerialization.jsonObject(with: expected) as? NSDictionary)
        #expect(encodedJSONObject == expectedJSONObject)
    }

    /// Flaky test, because order of JSON object elements is random during runs.
    /// On failure, compare output strings.
    @Test
    func encodeNSNumberBoolean() throws {
        let jsonString = #"{"boolean":true,"int":0}"#
        let json = try #require(jsonString.data(using: .utf8))
        let jsonObject = try #require(try JSONSerialization.jsonObject(with:  json) as? [String: any Sendable])

        let anyCodable = AnyCodable(jsonObject)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let encoded = try encoder.encode(anyCodable)
        #expect(String(data: encoded, encoding: .utf8) == jsonString)
    }

    @Test
    func encodeNSNumberOneAndZeroAsInt() throws {
        let dictionary: [NSNumber] = [0, 1]
        let encoder = JSONEncoder()
        let json = try encoder.encode(AnyEncodable(dictionary))
        #expect(String(data: json, encoding: .utf8) == "[0,1]")
    }
}
