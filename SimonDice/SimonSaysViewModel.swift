//
//  SimonSaysViewModel.swift
//  SimonDice
//
//  Created by Marco Alonso Rodriguez on 16/12/24.
//

//  Descripción:
//  Clase que implementa la lógica principal del juego Simon Says.
//  Gestiona la secuencia de colores, las acciones del jugador,
//  los niveles, la puntuación y los estados de la aplicación.
//
//  Uso:
//  Se utiliza como ViewModel en la arquitectura MVVM,
//  conectándose a la vista a través de @Published variables.
//

import SwiftUI

/// `GameViewModel` gestiona la lógica principal del juego Simon Says.
class GameViewModel: ObservableObject {
    // MARK: - Propiedades Publicadas
    @Published var colorSequence: [ColorOption] = []  // Secuencia generada por el juego
    @Published var userSequence: [ColorOption] = []   // Secuencia ingresada por el jugador
    @Published var currentHighlightedColor: ColorOption? = nil // Color actualmente resaltado
    @Published var level: Int = 1                    // Nivel actual del juego
    @Published var isGameOver: Bool = false          // Estado de Game Over
    @Published var isShowingSuccessModal: Bool = false // Modal de éxito
    @Published var score: Int = 0                    // Puntuación del jugador
    @Published var isPlayingSequence: Bool = false   // Indica si se está reproduciendo la secuencia

    // MARK: - Métodos Públicos

    /// Inicia un nuevo juego.
    func startGame() {
        isGameOver = false
        isPlayingSequence = true
        
        // Agrega un delay de 0.6 segundos antes de iniciar el juego
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.resetGame()
            self.addNextColor()
            self.playSequence()
        }
    }

    /// Verifica la elección del usuario.
    /// - Parameter color: El color que el usuario seleccionó.
    func checkUserChoice(_ color: ColorOption) {
        guard !isPlayingSequence else { return } // Evita interacción durante la secuencia
        userSequence.append(color)
        
        if userSequence == Array(colorSequence.prefix(userSequence.count)) {
            if userSequence.count == colorSequence.count {
                score += 1
                isShowingSuccessModal = true // Muestra el modal de éxito
            }
        } else {
            isGameOver = true // Termina el juego si hay un error
        }
    }

    /// Avanza al siguiente nivel.
    func nextLevel() {
        level += 1
        addNextColor()
        playSequence()
    }

    // MARK: - Métodos Privados

    /// Reinicia el juego a su estado inicial.
    private func resetGame() {
        colorSequence = []
        userSequence = []
        currentHighlightedColor = nil
        level = 1
        score = 0
        isGameOver = false
        isPlayingSequence = false
    }

    /// Agrega un color aleatorio a la secuencia del juego.
    private func addNextColor() {
        colorSequence.append(ColorOption.allCases.randomElement()!)
        userSequence = []
    }

    /// Reproduce la secuencia de colores resaltando cada botón uno por uno.
    private func playSequence() {
        isPlayingSequence = true
        currentHighlightedColor = nil
        
        for (index, color) in colorSequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.0) {
                self.currentHighlightedColor = color
                ColorSoundPlayer.shared.playSound(for: color.name)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.currentHighlightedColor = nil
                    if index == self.colorSequence.count - 1 {
                        self.isPlayingSequence = false // Finaliza la secuencia
                    }
                }
            }
        }
    }
}


