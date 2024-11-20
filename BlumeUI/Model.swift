//
//  Model.swift
//  BlumeUI
//
//  Created by Robert Langer on 11/20/24.
//

import SwiftUI
import GRDB

@Observable class Model {
    var session: String = "" {
        didSet {
            do {
                try update()
            } catch {
                print(error)
            }
        }
    }
    
    var scriptid: Int = -1 {
        didSet {
            do {
                try update()
            } catch {
                print(error)
            }
        }
    }
    
    var sessions: [String] = [""]
    var scripts: [Int] = [-1]
    var entries: [BlumeRow] = []
    
    var db: DatabaseQueue
    
    init(from db: DatabaseQueue) throws {
        self.db = db
        
        let (sessions, scripts) = try db.read { db in
            let sessions = try String.fetchAll(db, sql: "SELECT DISTINCT session FROM translations ORDER BY session")
            let scripts = try Int.fetchAll(db, sql: "SELECT id FROM scripts WHERE id >= 100 AND id < 200 ORDER BY id")
            
            return (sessions, scripts)
        }
        
        self.session = ""
        self.scriptid = -1
        self.entries = []
        self.sessions = [""] + sessions
        self.scripts = [-1] + scripts
    }
    
    private func update() throws {
        if session.isEmpty || scriptid == -1 {
            entries = []
            return
        }
        
        try db.read { db in
            let rows = try Row.fetchCursor(db, sql: """
                SELECT lines.address, speaker, line, COALESCE(translation, '') AS translation
                FROM lines LEFT JOIN translations
                ON (?, lines.scriptid, lines.address) = (translations.session, translations.scriptid, translations.address)
                WHERE lines.scriptid = ?
                ORDER BY lines.address
            """, arguments: [session, scriptid])
            var newRows: [BlumeRow] = []
            try rows.forEach({ row in
                newRows.append(BlumeRow(
                    address: row["address"],
                    speaker: row["speaker"],
                    original: row["line"],
                    translation: row["translation"]
                ))
            })
            self.entries = newRows
        }
    }
}
