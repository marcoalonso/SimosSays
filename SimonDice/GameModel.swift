//
//  GameModel.swift
//  SimonDice
//
//  Created by Marco Alonso Rodriguez on 16/12/24.
//

import Foundation

enum ColorOption: CaseIterable {
    case red, green, blue, yellow, orange, purple, pink, cyan

    /// Nombre del color como texto.
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

    /// Nombre de la imagen del animal asociada a cada color.
    var animalImageName: String {
        switch self {
        case .red: return "fox"       // Imagen asociada al color rojo
        case .green: return "zebra"    // Imagen asociada al color verde
        case .blue: return "monkey"   // Imagen asociada al color azul
        case .yellow: return "tiger"  // Imagen asociada al color amarillo
        case .orange: return "giraffe"// Imagen asociada al color naranja
        case .purple: return "panda"// Imagen asociada al color morado
        case .pink: return "elephant" // Imagen asociada al color rosa
        case .cyan: return "lion"     // Imagen asociada al color cian
        }
    }

    /// Nombre del archivo de sonido asociado a cada color.
    var soundName: String {
        switch self {
        case .red: return "red"       // Archivo de sonido para rojo
        case .green: return "green"   // Archivo de sonido para verde
        case .blue: return "blue"     // Archivo de sonido para azul
        case .yellow: return "yellow" // Archivo de sonido para amarillo
        case .orange: return "orange" // Archivo de sonido para naranja
        case .purple: return "purple" // Archivo de sonido para morado
        case .pink: return "pink"     // Archivo de sonido para rosa
        case .cyan: return "cyan"     // Archivo de sonido para cian
        }
    }
}
