//
//  BlumeUIApp.swift
//  BlumeUI
//
//  Created by Robert Langer on 11/19/24.
//

import SwiftUI
import UniformTypeIdentifiers
import GRDB

@main
struct BlumeUIApp: App {
    @State private var isImporting = true
    
    var body: some Scene {
        WindowGroup(id: "editor", for: URL.self) { $url in
            if let url {
                if url.startAccessingSecurityScopedResource() {
                    let filename = url.lastPathComponent
                    
                    try! ContentView(url: url)
                        .navigationTitle(filename.isEmpty ? "BlumeUI" : filename)
                }
            }
        }
        .defaultLaunchBehavior(.suppressed) // Don't open default window
        .commands {
            CommandGroup(after: CommandGroupPlacement.newItem) {
                @Environment(\.openWindow) var openWindow
                
                Button("Open...") {
                    isImporting = true
                }
                .keyboardShortcut("o", modifiers: [.command])
                .fileImporter(isPresented: $isImporting, allowedContentTypes: [UTType.data]) {
                    do {
                        let url = try $0.get()
                        openWindow(id: "editor", value: url)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
    
