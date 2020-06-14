//
//  TypeListEntry.swift
//  aetherdb
//
//  Created by user175976 on 6/13/20.
//  Copyright © 2020 GameCult. All rights reserved.
//

import SwiftUI

struct SimpleListEntry: View {
    var name : String
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
        }
        .contentShape(Rectangle())
        .padding()
    }
}

struct TypeListEntry_Previews: PreviewProvider {
    static var previews: some View {
        SimpleListEntry(name: "Example Type Name")
    }
}
