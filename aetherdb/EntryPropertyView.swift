//
//  EntryPropertyView.swift
//  aetherdb
//
//  Created by user175976 on 6/15/20.
//  Copyright © 2020 GameCult. All rights reserved.
//

import SwiftUI

struct EntryPropertyView: View {
    var name: String
    var value: String
    
    var body: some View {
        HStack {
            Text(name)
                .bold()
            Spacer()
            Text(value)
        }
        .contentShape(Rectangle())
        .padding()
    }
}

struct EntryPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        EntryPropertyView(name: "Name", value: "Value")
    }
}
