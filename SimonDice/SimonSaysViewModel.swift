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

/// `GameViewModel` es la clase que controla toda la lógica del juego Simon Says.
/// Se utiliza para almacenar el estado del juego, manejar las secuencias de colores,
/// procesar la entrada del usuario y gestionar los niveles y la puntuación.
class GameViewModel: ObservableObject {
    
    // MARK: - Propiedades Publicadas
    
    /// La secuencia de colores que el jugador debe seguir.
    @Published var colorSequence: [ColorOption] = []
    
    /// La secuencia de colores que el usuario ha ingresado hasta ahora.
    @Published var userSequence: [ColorOption] = []
    
    /// El color actualmente destacado durante la reproducción de la secuencia.
    @Published var currentHighlightedColor: ColorOption? = nil
    
    /// El nivel actual del juego.
    @Published var level: Int = 1
    
    /// Indicador que muestra si el jugador ha perdido el juego.
    @Published var isGameOver: Bool = false
    
    /// Indicador que muestra si se debe mostrar el modal de éxito.
    @Published var isShowingSuccessModal: Bool = false
    
    /// La puntuación actual del jugador basada en los niveles completados.
    @Published var score: Int = 0

    // MARK: - Métodos Públicos
    
    /// Inicia una nueva partida, reiniciando el estado del juego y comenzando con la primera secuencia.
    func startGame() {
        resetGame()
        addNextColor()
        playSequence()
    }
    
    /// Reinicia el juego a su estado inicial.
    ///
    /// Resetea las secuencias de colores, el nivel, la puntuación y los indicadores de estado.
    func resetGame() {
        colorSequence = []
        userSequence = []
        currentHighlightedColor = nil
        level = 1
        score = 0
        isGameOver = false
    }
    
    /// Agrega un nuevo color aleatorio a la secuencia del juego.
    ///
    /// Se llama al final de cada nivel para aumentar la dificultad.
    func addNextColor() {
        colorSequence.append(ColorOption.allCases.randomElement()!)
        userSequence = []
    }
    
    /// Reproduce la secuencia de colores para que el jugador la memorice.
    ///
    /// Resalta cada color de la secuencia uno por uno con un pequeño retraso entre cada uno.
    func playSequence() {
        currentHighlightedColor = nil
        let sequence = colorSequence
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animateSequence(sequence: sequence)
        }
    }
    
    /// Verifica la elección del usuario.
    ///
    /// - Parameter color: El color que el usuario seleccionó.
    /// - Si la secuencia ingresada es correcta, avanza al siguiente nivel.
    /// - Si el usuario comete un error, el juego termina.
    func checkUserChoice(_ color: ColorOption) {
        userSequence.append(color)
        if userSequence == Array(colorSequence.prefix(userSequence.count)) {
            if userSequence.count == colorSequence.count {
                score += 1
                isShowingSuccessModal = true
            }
        } else {
            isGameOver = true
        }
    }
    
    /// Avanza al siguiente nivel después de que el jugador haya completado la secuencia correctamente.
    ///
    /// Aumenta el nivel actual, agrega un nuevo color a la secuencia y reproduce la secuencia actualizada.
    func nextLevel() {
        level += 1
        addNextColor()
        isShowingSuccessModal = false
        playSequence()
    }

    // MARK: - Métodos Privados
    
    /// Anima la secuencia de colores resaltando cada color uno por uno.
    ///
    /// - Parameter sequence: La secuencia de colores a animar.
    private func animateSequence(sequence: [ColorOption]) {
        for (index, color) in sequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.0) {
                self.currentHighlightedColor = color
                ColorSoundPlayer.shared.playSound(for: color.name)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.currentHighlightedColor = nil
                }
            }
        }
    }
}
