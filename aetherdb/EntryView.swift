//
//  EntryView.swift
//  aetherdb
//
//  Created by user175976 on 6/14/20.
//  Copyright © 2020 GameCult. All rights reserved.
//

import SwiftUI
import Rethink

struct EntryView: View {
    var entry: ReDocument
    var keys: [String]
    var linkKeys: [String] = []
    @ObservedObject var linkQueryResults: RethinkQueryResultCollection = RethinkQueryResultCollection(entries: [])
    var simpleKeys: [String] = []
    var numericKeys: [String] = []
    var documentKeys: [String] = []
    var otherKeys: [String] = []
    var name: String = ""
    
    init(entry: ReDocument) {
        self.init(entry: entry, name: entry["name"] as! String)
    }
    
    init(entry: ReDocument, name: String) {
        self.entry = entry
        keys = entry.filter{$0.key != "id" && $0.key != "$type" && $0.key != "description" && $0.key != "name"}.map{$0.key}
        linkKeys = keys.filter{entry[$0] is String && UUID(uuidString: entry[$0] as! String) != nil}
        linkQueryResults = RethinkQueryResultCollection(entries: linkKeys.map{RethinkConnection.getEntry(self.entry[$0] as! String)})
        simpleKeys = keys.filter{entry[$0] is String && !(linkKeys.contains($0))}
        numericKeys = keys.filter{entry[$0] is NSNumber}
        documentKeys = keys.filter{entry[$0] is ReDocument}
        otherKeys = keys.filter{!(linkKeys.contains($0)) && !(simpleKeys.contains($0)) && !(numericKeys.contains($0)) && !(documentKeys.contains($0))}
        self.name = name
    }
    
    var body: some View {
        return List {
            if(entry["description"] != nil && !(entry["description"] is NSNull)){
                Text(entry["description"] as! String)
                    .padding()
            }
            ForEach(linkKeys.indices) { index in
                return NavigationLink(destination: EntryView(entry: self.linkQueryResults.entries[index].entry)) {
                    EntryPropertyView(name: self.linkKeys[index], value: self.linkQueryResults.entries[index].entry["name"] as! String)
                }
            }
            ForEach(documentKeys.sorted(), id: \.self) { key in
                return NavigationLink(destination: EntryView(entry: self.entry[key] as! ReDocument, name: key)) {
                    SimpleListEntry(name: key)
                }
            }
            ForEach(numericKeys.sorted(), id: \.self) {key in
                EntryPropertyView(name: key, value: (self.entry[key] as! NSNumber).description)
            }
            ForEach(simpleKeys.sorted(), id: \.self) {key in
                EntryPropertyView(name: key, value: self.entry[key] as! String)
            }
            ForEach(otherKeys.sorted(), id: \.self) {key in
                SimpleListEntry(name: key)
            }
        }
        .navigationBarTitle(Text(name))
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: ["name":"Sample", "description":"This is a sample entry"])
    }
}
