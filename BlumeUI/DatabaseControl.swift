//
//  DatabaseControl.swift
//  BlumeUI
//
//  Created by Robert Langer on 11/20/24.
//

import SwiftUI

struct DatabaseControl: View {
    @Environment(Model.self) var model
    
    var body: some View {
        @Bindable var model = model
        
        HStack {
            Spacer()
            
            // Session Picker
            Picker("Session", selection: $model.session) {
                ForEach(model.sessions, id: \.self) { Text($0) }
            }
            
            Spacer()

            // Script ID Picker
            Picker("Script ID", selection: $model.scriptid) {
                ForEach(model.scripts, id: \.self) {
                    if $0 == -1 {
                        Text("")
                    } else {
                        Text(String($0))
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}

