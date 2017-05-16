import Foundation
import Vapor
 
struct User: Model {
    var exists: Bool = false
    var id: Node?
    let name: String
    let beer: Int?
    
    init(name: String, beer: Int?) {
        self.name = name
        self.beer = beer
    }
    
    //Intializable from a Node
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        beer = try node.extract("beer")
    }
    
    //Node represantable
    func makeNode(context: Context) throws -> Node {
        return try Node(node: ["id": id,
                               "name": name,
                               "beer": beer])
    }
    
    //Database preparation
    static func prepare(_ database: Database) throws {
        try database.create("users") {users in
            users.id()
            users.string("name")
            users.int("beer", optional: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
}
