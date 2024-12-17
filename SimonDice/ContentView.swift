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

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                // MARK: - Cuadrícula de Botones de Colores
                VStack(spacing: 10) {
                    ForEach(gridColors(), id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row, id: \.self) { color in
                                Button(action: {
                                    viewModel.checkUserChoice(color)
                                    ColorSoundPlayer.shared.playSound(for: color.name)
                                }) {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(viewModel.currentHighlightedColor == color ? Color.white : colorToSwiftUIColor(color))
                                        .frame(
                                            width: (geometry.size.width / 2) - 20,
                                            height: (geometry.size.height / 5) - 10
                                        )
                                        .shadow(radius: viewModel.currentHighlightedColor == color ? 10 : 0)
                                        .scaleEffect(viewModel.currentHighlightedColor == color ? 1.1 : 1.0)
                                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentHighlightedColor)
                                }
                                .disabled(viewModel.isPlayingSequence)
                            }
                        }
                    }
                }

                // MARK: - Indicador del Nivel
                Circle()
                    .fill(Color.blue.opacity(0.7))
                    .frame(width: 100, height: 100)
                    .shadow(radius: 10)
                    .overlay(
                        Text("Nivel \(viewModel.level)")
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()
                    )

                // MARK: - Estado del Turno con Animación
                Text(viewModel.isPlayingSequence ? "Espera" : "Tu turno")
                    .font(.title)
                    .foregroundColor(viewModel.isPlayingSequence ? .red : .green)
                    .scaleEffect(viewModel.isPlayingSequence ? 1.1 : 1.3)
                    .animation(.spring(response: 0.5, dampingFraction: 0.5), value: viewModel.isPlayingSequence)
                    .bold()
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .onAppear {
            viewModel.startGame()
        }
        .zIndex(0) // Evita que los modales se oculten por debajo

        // MARK: - Modales
        if viewModel.isShowingSuccessModal {
            SuccessModal(level: viewModel.level, nextAction: {
                withAnimation {
                    viewModel.nextLevel()
                    viewModel.isShowingSuccessModal = false
                }
            })
            .zIndex(1)
        }

        if viewModel.isGameOver {
            GameOverModal(score: viewModel.score, restartAction: {
                withAnimation {
                    viewModel.startGame()
                }
            })
            .zIndex(1)
        }
    }

    // MARK: - Métodos Auxiliares

    private func gridColors() -> [[ColorOption]] {
        let allColors = ColorOption.allCases
        return stride(from: 0, to: allColors.count, by: 2).map {
            Array(allColors[$0..<min($0 + 2, allColors.count)])
        }
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
