//
//  RethinkConnection.swift
//  aetherdb
//
//  Created by user175976 on 6/13/20.
//  Copyright © 2020 GameCult. All rights reserved.
//

import Foundation
import Rethink

struct TypeItem: Identifiable {
    let id = UUID()
    let name: String
}

class TypeResults: ObservableObject {
    @Published var types: [TypeItem]
    init(){
        self.types = []
    }
}

struct DatabaseEntry: Identifiable {
    let id : UUID
    let doc: ReDocument
}

class RethinkQueryResults: ObservableObject {
    @Published var entries: [DatabaseEntry]
    init(){
        self.entries = []
    }
}

class RethinkQueryResult: ObservableObject {
    @Published var entry: ReDocument
    init(){
        self.entry = ["name":"Unavailable"]
    }
}

class RethinkQueryResultCollection: ObservableObject {
    @Published var entries: [RethinkQueryResult]
    init(entries: [RethinkQueryResult]) {
        self.entries = entries
    }
}

class RethinkConnection {
    static let Url = URL(string: "rethinkdb://asgard.gamecult.games:28015")!
    
    static func getTypes() -> TypeResults {
        var types = TypeResults()
        R.connect(Url) { (err, connection) in
            assert(err==nil, "Connection error: \(String(describing: err))")
            
            R.db("Aetheria").table("Items").map({i in return i["$type"]}).distinct( ).run(connection) { response in
                DispatchQueue.main.async(){
                    types.types = (response.value as! [String]).map { TypeItem(name: $0) }
                }
            }
        }
        return types
    }
    
    static func getEntry(_ guid: String) -> RethinkQueryResult {
        //print("Querying for entry with id: \(guid)")
        var result = RethinkQueryResult()
        R.connect(Url) { (err, connection) in
            assert(err==nil, "Connection error: \(String(describing: err))")
            
            R.db("Aetheria").table("Items").get(guid).run(connection) { response in
                DispatchQueue.main.async(){
                    result.entry = response.value as? ReDocument ?? ["name":"Not Found"]
                }
            }
        }
        return result
    }
    
    static func getItemsOfType(_ type: String) -> RethinkQueryResults {
        var results = RethinkQueryResults()
        R.connect(Url) { (err, connection) in
            assert(err==nil, "Connection error: \(String(describing: err))")
            
            R.db("Aetheria").table("Items").filter({i in return i["$type"].eq(R.expr(type))}).run(connection) { (response: ReResponse) -> () in
                DispatchQueue.main.async(){
                    switch response {
                    case .rows(let docs, _):
                        results.entries = docs.map { (document:ReDocument) -> DatabaseEntry in
                            return DatabaseEntry(id: UUID(uuidString: document["id"] as! String)!, doc: document)
                        }
                    default:
                        print("Unknown response")
                    }
                }
            }
        }
        return results
    }
}
