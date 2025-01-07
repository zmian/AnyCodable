# AnyCodable

[![Build Status][build status badge]][build status]
[![License][license badge]][license]
[![Swift Version][swift version badge]][swift version]
![Cocoapods platforms][cocoapods platforms badge]
[![Cocoapods compatible][cocoapods badge]][cocoapods]
[![Carthage compatible][carthage badge]][carthage]

Type-erased wrappers for `Encodable`, `Decodable`, and `Codable` values.

This functionality is discussed in Chapter 3 of
[Flight School Guide to Swift Codable](https://flight.school/books/codable).

## Installation

### Swift Package Manager

Add the AnyCodable package to your target dependencies in `Package.swift`:

```swift
import PackageDescription

let package = Package(
  name: "YourProject",
  dependencies: [
    .package(
        url: "https://github.com/Flight-School/AnyCodable",
        from: "0.6.0"
    ),
  ]
)
```

Then run the `swift build` command to build your project.

## Usage

### AnyEncodable

```swift
import AnyCodable

let dictionary: [String: AnyEncodable] = [
    "boolean": true,
    "integer": 1,
    "double": 3.141592653589793,
    "string": "string",
    "array": [1, 2, 3],
    "nested": [
        "a": "alpha",
        "b": "bravo",
        "c": "charlie"
    ],
    "null": nil
]

let encoder = JSONEncoder()
let json = try! encoder.encode(dictionary)
```

### AnyDecodable

```swift
let json = """
{
    "boolean": true,
    "integer": 1,
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
""".data(using: .utf8)!

let decoder = JSONDecoder()
let dictionary = try! decoder.decode([String: AnyDecodable].self, from: json)
```

### AnyCodable

`AnyCodable` can be used to wrap values for encoding and decoding.

## License

MIT

## Contact

Mattt ([@mattt](https://twitter.com/mattt))

[build status]: https://github.com/Flight-School/AnyCodable/actions?query=workflow%3ACI
[build status badge]: https://github.com/Flight-School/AnyCodable/workflows/CI/badge.svg
[license]: https://opensource.org/licenses/MIT
[license badge]: https://img.shields.io/cocoapods/l/AnyCodable-FlightSchool.svg
[swift version]: https://swift.org/download/
[swift version badge]: https://img.shields.io/badge/swift%20version-5.1+-orange.svg
[cocoapods platforms badge]: https://img.shields.io/cocoapods/p/AnyCodable-FlightSchool.svg
[cocoapods]: https://cocoapods.org/pods/AnyCodable-FlightSchool
[cocoapods badge]: https://img.shields.io/cocoapods/v/AnyCodable-FlightSchool.svg
[carthage]: https://github.com/Carthage/Carthage
[carthage badge]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg
