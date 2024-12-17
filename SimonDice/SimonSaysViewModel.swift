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
import AVFoundation
import UIKit

/// ViewModel que controla la lógica del juego Simon Says.
class GameViewModel: ObservableObject {
    @Published var colorSequence: [ColorOption] = []       // Secuencia generada por el juego
    @Published var userSequence: [ColorOption] = []        // Secuencia ingresada por el usuario
    @Published var currentHighlightedColor: ColorOption? = nil // Color actualmente resaltado
    @Published var level: Int = 1                         // Nivel actual
    @Published var isGameOver: Bool = false               // Estado de Game Over
    @Published var isShowingSuccessModal: Bool = false    // Modal de éxito
    @Published var isPlayingSequence: Bool = false        // Indica si la secuencia está en reproducción
    @Published var score: Int = 0                         // Puntuación del usuario
    @Published var circleBackgroundColor: Color = .blue   // Color del círculo que indica el nivel

    /// Inicia un nuevo juego.
    func startGame() {
        resetGame()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.addNextColor()
            self.playSequence()
        }
    }

    /// Verifica la elección del usuario.
    func checkUserChoice(_ color: ColorOption) {
        guard !isPlayingSequence else { return } // Evita interacción durante la secuencia
        userSequence.append(color)
        
        if userSequence == Array(colorSequence.prefix(userSequence.count)) {
            if userSequence.count == colorSequence.count {
                score += 1
                isShowingSuccessModal = true // Muestra el modal de éxito
                triggerHapticFeedback()      // Activa la vibración háptica
            }
        } else {
            isGameOver = true // Termina el juego si hay un error
        }
    }

    /// Avanza al siguiente nivel.
    func nextLevel() {
        level += 1
        updateCircleColor()
        addNextColor()
        playSequence()
    }

    /// Reinicia el juego a su estado inicial.
    private func resetGame() {
        colorSequence = []
        userSequence = []
        currentHighlightedColor = nil
        level = 1
        score = 0
        isGameOver = false
    }

    /// Agrega un nuevo color a la secuencia.
    private func addNextColor() {
        colorSequence.append(ColorOption.allCases.randomElement()!)
        userSequence = []
    }

    /// Reproduce la secuencia de colores generada.
    func playSequence() {
        isPlayingSequence = true
        currentHighlightedColor = nil
        
        for (index, color) in colorSequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.0) {
                self.currentHighlightedColor = color
                ColorSoundPlayer.shared.playSound(for: color.soundName) // Reproduce el sonido
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.currentHighlightedColor = nil
                    if index == self.colorSequence.count - 1 {
                        self.isPlayingSequence = false
                    }
                }
            }
        }
    }
    
    /// Actualiza el color del círculo a un color aleatorio.
    private func updateCircleColor() {
        let randomColor: [Color] = [.red, .green, .blue, .yellow, .orange, .purple, .pink, .cyan]
        circleBackgroundColor = randomColor.randomElement() ?? .blue
    }
    
    /// Activa la vibración háptica al pasar de nivel.
    private func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
