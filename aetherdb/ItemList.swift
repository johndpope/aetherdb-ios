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
    var queryResults: RethinkQueryResults
    
    init(listType: String) {
        self.listType = listType
        self.queryResults = RethinkConnection.getItemsOfType(listType)
    }
    
    var body: some View {
        List(queryResults.entries) { entry in
            SimpleListEntry(name: entry.doc["name"] as! String)
        }
    }
    
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList(listType: "Loadout")
    }
}
