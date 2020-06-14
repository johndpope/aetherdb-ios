//
//  ContentView.swift
//  aetherdb
//
//  Created by user175976 on 6/10/20.
//  Copyright © 2020 GameCult. All rights reserved.
//

import SwiftUI
import Rethink


struct ContentView: View {
    @ObservedObject var types = RethinkConnection.getTypes()
    
    var body: some View {
        NavigationView {
            List(types.types) { itemType in
                NavigationLink(destination: ItemList(listType: itemType.name)){
                    SimpleListEntry(name: itemType.name) 
                }
            }
            .navigationBarTitle(Text("Entry Types"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
