//
//  Models.swift
//  To do List
//
//  Created by Sarah Hill on 2026-04-05.
//

import SwiftUI
import Swift

struct TodoList: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var tasks: [Task]
}

struct Task: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
}
