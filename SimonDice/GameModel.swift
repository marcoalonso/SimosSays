//
//  GameModel.swift
//  SimonDice
//
//  Created by Marco Alonso Rodriguez on 16/12/24.
//

import Foundation

enum ColorOption: CaseIterable {
    case red, green, blue, yellow, orange, purple, pink, cyan

    var name: String {
        switch self {
        case .red: return "red"
        case .green: return "green"
        case .blue: return "blue"
        case .yellow: return "yellow"
        case .orange: return "orange"
        case .purple: return "purple"
        case .pink: return "pink"
        case .cyan: return "cyan"
        }
    }
}
