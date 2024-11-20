//
//  ContentView.swift
//  BlumeUI
//
//  Created by Robert Langer on 11/19/24.
//

import SwiftUI

struct TranslationsEditor: View {
    @State private var selection: UInt64? = nil
    @Environment(Model.self) private var model
    
    private struct Sidebar: View {
        @Binding var row: BlumeRow
        @State private var tempTranslation: String = ""

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Details Section
                Group {
                    Text("Details")
                        .font(.title3)
                        .bold()

                    Text("Address: \(String(row.address))")
                        .font(.body)

                    Text("Speaker: \(row.speaker.isEmpty ? "<none>" : row.speaker)")
                        .font(.body)
                }

                Divider()

                // Original Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Original")
                        .font(.headline)

                    ScrollView {
                        Text(row.original)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 100)
                }

                Divider()

                // Translation Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Edit Translation")
                        .font(.headline)

                    TextEditor(text: $tempTranslation)
                        .font(.body)
                        .border(Color.gray.opacity(0.5))
                        .frame(maxWidth: .infinity, maxHeight: 100)

                    HStack {
                        Spacer()

                        Button("Save") {
                            row.translation = tempTranslation // Save changes
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color(NSColor.windowBackgroundColor))
            .onAppear {
                tempTranslation = row.translation // Initialize tempTranslation
            }
            .onChange(of: row) { _, newRow in
                tempTranslation = newRow.translation // Reset tempTranslation when selection changes
            }
        }
    }
    
    var body: some View {
        @Bindable var model = model
        
        GeometryReader { geo in
            HStack {
                Table(model.entries, selection: $selection) {
                    TableColumn("Address") { row in Text(String(row.address)) }
                    TableColumn("Speaker", value: \.speaker)
                    TableColumn("Original", value: \.original)
                    TableColumn("Translation", value: \.translation)
                }
                .frame(width: geo.size.width * 0.7)
                
                if let selection {
                    if let index = model.entries.firstIndex(where: { $0.address == selection }) {
                        Sidebar(row: $model.entries[index])
                            .frame(width: geo.size.width * 0.3)
                            .background(Color(NSColor.windowBackgroundColor))
                            .border(Color.gray.opacity(0.2), width: 1)
                    }
                }
            }
        }
        .padding()
        .onChange(of: model.session) {
            selection = nil
        }
        .onChange(of: model.scriptid) {
            selection = nil
        }
    }
}

//#Preview {
//    ContentView(rows: nil)
//}
