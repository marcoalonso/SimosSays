//
//  ContentView.swift
//  SimonDice
//
//  Created by Marco Alonso Rodriguez on 16/12/24.

//  Descripción:
//  Vista principal del juego Simon Says.
//  Muestra el nivel actual, la cuadrícula de botones de colores y
//  los modales para indicar el éxito o el final del juego.
//
//  Uso:
//  `ContentView` se conecta con el ViewModel (`GameViewModel`) para
//  manejar la lógica del juego y actualizar la interfaz de usuario.
//

import SwiftUI

/// `ContentView` representa la interfaz principal del juego Simon Says.
///
/// La vista incluye:
/// - Un indicador animado del nivel actual.
/// - Una cuadrícula de botones de colores que el jugador debe presionar en secuencia.
/// - Modales que aparecen cuando el jugador avanza de nivel o pierde el juego.
struct ContentView: View {
    
    /// ViewModel que controla la lógica del juego.
    @StateObject private var viewModel = GameViewModel()
    
    // MARK: - Cuerpo de la Vista
    var body: some View {
        ZStack {
            VStack {
                // MARK: - Indicador de Nivel
                Circle()
                    .fill(Color.blue.opacity(0.7)) // Fondo azul semi-transparente
                    .frame(width: 150, height: 150) // Tamaño del círculo
                    .shadow(radius: 10) // Sombra del círculo
                    .scaleEffect(1.1) // Efecto de escala pulsante
                    .animation(
                        Animation.easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                        value: viewModel.level
                    )
                    .overlay(
                        Text("Level \(viewModel.level)") // Muestra el nivel actual
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .bold()
                    )
                
                // MARK: - Cuadrícula de Colores
                VStack {
                    ForEach(gridColors(), id: \.self) { row in
                        HStack {
                            ForEach(row, id: \.self) { color in
                                Button(action: {
                                    viewModel.checkUserChoice(color) // Comprueba la elección del jugador
                                    ColorSoundPlayer.shared.playSound(for: color.name) // Reproduce un sonido
                                }) {
                                    Rectangle()
                                        .fill(viewModel.currentHighlightedColor == color ? Color.white : colorToSwiftUIColor(color))
                                        .frame(width: 80, height: 80) // Tamaño del botón
                                        .cornerRadius(10) // Esquinas redondeadas
                                        .shadow(radius: viewModel.currentHighlightedColor == color ? 10 : 0)
                                        .scaleEffect(viewModel.currentHighlightedColor == color ? 1.1 : 1.0) // Efecto de escala si está seleccionado
                                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentHighlightedColor)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            
            // MARK: - Modal de Éxito
            if viewModel.isShowingSuccessModal {
                SuccessModal(level: viewModel.level, nextAction: {
                    withAnimation {
                        viewModel.nextLevel()
                    }
                })
                .zIndex(1) // Prioriza el modal en la pila de vistas
            }
            
            // MARK: - Modal de Game Over
            if viewModel.isGameOver {
                GameOverModal(score: viewModel.score, restartAction: {
                    withAnimation {
                        viewModel.startGame()
                    }
                })
                .zIndex(1) // Prioriza el modal en la pila de vistas
            }
        }
        .onAppear {
            viewModel.startGame() // Inicializa el juego cuando la vista aparece
        }
    }
    
    // MARK: - Métodos Auxiliares
    
    /// Devuelve una cuadrícula de colores dividida en dos filas.
    ///
    /// - Returns: Un arreglo de arreglos de `ColorOption`.
    private func gridColors() -> [[ColorOption]] {
        let allColors = ColorOption.allCases
        return [Array(allColors.prefix(4)), Array(allColors.suffix(4))]
    }
    
    /// Convierte una opción de color `ColorOption` en un color de SwiftUI.
    ///
    /// - Parameter color: La opción de color a convertir.
    /// - Returns: Un color de SwiftUI correspondiente a la opción.
    private func colorToSwiftUIColor(_ color: ColorOption) -> Color {
        switch color {
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        case .yellow: return .yellow
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        case .cyan: return .cyan
        }
    }
}

#Preview {
    ContentView()
}
