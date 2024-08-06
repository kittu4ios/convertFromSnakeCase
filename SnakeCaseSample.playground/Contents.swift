import UIKit
import Foundation


/*
 Case 1: Basic Usage of .convertFromSnakeCase

 */
struct BasicUser: Codable {
    var firstName: String
    var lastName: String
}

let jsonData = """
{
    "first_name": "Krishna",
    "last_name": "Prakash"
}
""".data(using: .utf8)!

print(jsonData)

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

do {
    let user = try decoder.decode(BasicUser.self, from: jsonData)
    print(user)
    // Output: User(firstName: "Krishna", lastName: "Prakash")
} catch {
    print(error)
}
//================================

/*
 Case 2: Customizing CodingKey
 */

struct DemoUser: Codable {
    var id: String
    var name: String
    var email: String

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name = "user_name"
        case email = "user_email"
    }
}

let userJsonData = """
{
    "user_id": "ABCD1528",
    "user_name": "Krishna",
    "user_email": "kpmobileappdeveloper@gmail.com"
}
""".data(using: .utf8)!

let decoder1 = JSONDecoder()

do {
    let user = try decoder1.decode(DemoUser.self, from: userJsonData)
    print(user)
    // Output: DemoUser(id: "ABCD1528", name: "Krishna", email: "kpmobileappdeveloper@gmail.com")
} catch {
    print(error)
}
//================================

/*
 Case 3: Combining Custom CodingKey with .convertFromSnakeCase
 */

struct CustomUser: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String

    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case firstName = "firstName"
        case lastName = "lastName"
        case email = "userEmail"
    }
}

let customJsonData = """
{
    "user_id": "ABCD1528",
    "first_name": "Krishna",
    "last_name": "Prakash",
    "user_email": "kpmobileappdeveloper@gmail.com"
}
""".data(using: .utf8)!

let decoder2 = JSONDecoder()
decoder2.keyDecodingStrategy = .convertFromSnakeCase

do {
    let user = try decoder2.decode(CustomUser.self, from: customJsonData)
    print(user)
    // Output: CustomUser(id: "ABCD1528", firstName: "Krishna", lastName: "Prakash", email: "kpmobileappdeveloper@gmail.com")
} catch {
    print(error)
}

/*
 Case 4: leading and trailing _ (underscore) or __ (double underscore)
 Note: convertFromSnakeCase will not work for leading and trailing underscores.
 means _first_name is
 */

let detailJsonData = """
{
    "_first_name": "Krishna",
    "last_name_": "Prakash"
}
""".data(using: .utf8)!

print(jsonData)

let decoder4 = JSONDecoder()
decoder4.keyDecodingStrategy = .convertFromSnakeCase

do {
    let user = try decoder4.decode(BasicUser.self, from: detailJsonData)
    print(user)
} catch {
    print(error)
    //Output: keyNotFound(CodingKeys(stringValue: "firstName", intValue: nil), Swift.DecodingError.Context(codingPath: [], debugDescription: "No value associated with key CodingKeys(stringValue: \"firstName\", intValue: nil) (\"firstName\").", underlyingError: nil))
}

/*
 Test convertFromSnakeCase expected key string
 */
let snakeCaseKey = "_first__name_"

extension JSONDecoder.KeyDecodingStrategy {
    static func convertFromSnakeCase(_ key: String) -> String {
        guard !key.isEmpty else { return key }

        let components = key.split(separator: "_")
        let leadingUnderscores = key.prefix(while: { $0 == "_" })
        let trailingUnderscores = key.reversed().prefix(while: { $0 == "_" }).reversed()
        let capitalizedComponents = components.enumerated().map { index, component in
            index == 0 ? component.lowercased() : component.capitalized
        }
        let joined = capitalizedComponents.joined()
        return leadingUnderscores + joined + trailingUnderscores
    }
}


let camelCaseKey = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase(snakeCaseKey)
print(camelCaseKey)
