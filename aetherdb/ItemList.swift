//
//  ItemList.swift
//  aetherdb
//
//  Created by user175976 on 6/14/20.
//  Copyright © 2020 GameCult. All rights reserved.
//

import SwiftUI

struct ItemList: View {
    var listType: String
    @ObservedObject var queryResults: RethinkQueryResults
    
    init(listType: String) {
        self.listType = listType
        self.queryResults = RethinkConnection.getItemsOfType(listType)
    }
    
    var body: some View {
        List(queryResults.entries) { entry in
            NavigationLink(destination: EntryView(entry: entry.doc)) {
                SimpleListEntry(name: entry.doc["name"] as! String)
            }
        }
        .navigationBarTitle(Text(listType))
    }
    
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList(listType: "Loadout")
    }
}
