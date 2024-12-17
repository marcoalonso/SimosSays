//
//  ContentView.swift
//  SimonDice
//
//  Created by Marco Alonso Rodriguez on 16/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel() // Instancia del ViewModel

    var body: some View {
        ZStack {
            VStack {
                // Indicador del nivel en el centro
                Circle()
                    .fill(Color.blue.opacity(0.7))
                    .frame(width: 150, height: 150)
                    .shadow(radius: 10)
                    .scaleEffect(1.1) // Efecto de pulso
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

                // Cuadrícula de botones de colores
                VStack {
                    ForEach(gridColors(), id: \.self) { row in
                        HStack {
                            ForEach(row, id: \.self) { color in
                                Button(action: {
                                    viewModel.checkUserChoice(color) // Verifica la elección del usuario
                                    ColorSoundPlayer.shared.playSound(for: color.name) // Reproduce sonido
                                }) {
                                    Rectangle()
                                        .fill(viewModel.currentHighlightedColor == color ? Color.white : colorToSwiftUIColor(color)) // Destaca el color presionado
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(10)
                                        .shadow(radius: viewModel.currentHighlightedColor == color ? 10 : 0)
                                        .scaleEffect(viewModel.currentHighlightedColor == color ? 1.1 : 1.0)
                                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentHighlightedColor)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            
            // Modal de éxito
            if viewModel.isShowingSuccessModal {
                SuccessModal(level: viewModel.level, nextAction: {
                    withAnimation {
                        viewModel.nextLevel()
                    }
                })
                .zIndex(1) // Asegura que el modal esté en la parte superior
            }
            
            // Modal de Game Over
            if viewModel.isGameOver {
                GameOverModal(score: viewModel.score, restartAction: {
                    withAnimation {
                        viewModel.startGame()
                    }
                })
                .zIndex(1)
            }
        }
        .onAppear {
            viewModel.startGame() // Inicia el juego al aparecer la vista
        }
    }

    private func gridColors() -> [[ColorOption]] {
        let allColors = ColorOption.allCases
        return [Array(allColors.prefix(4)), Array(allColors.suffix(4))] // Divide los colores en dos filas
    }

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
