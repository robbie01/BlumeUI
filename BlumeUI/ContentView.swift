//
//  ContentView.swift
//  BlumeUI
//
//  Created by Robert Langer on 11/20/24.
//

import SwiftUI
import UniformTypeIdentifiers
import GRDB

struct ContentView: View {
    @State private var model: Model
    @State private var isImporting = false
    
    init(url: URL) throws {
        let db = try DatabaseQueue(path: url.path(percentEncoded: false))
        url.stopAccessingSecurityScopedResource()
        model = try Model(from: db)
    }
    
    var body: some View {
        VStack {
            DatabaseControl()
            TranslationsEditor()
        }
        .environment(model)
    }
}
