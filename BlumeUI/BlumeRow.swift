//
//  BlumeRow.swift
//  BlumeUI
//
//  Created by Robert Langer on 11/20/24.
//


import SwiftUI

struct BlumeRow: Identifiable & Equatable {
        let address: UInt64
        let speaker: String
        let original: String
        var translation: String
        
        var id: UInt64 { address }
    }