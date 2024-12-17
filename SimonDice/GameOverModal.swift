//
//  GameOverModal.swift
//  SimonDice
//
//  Created by Marco Alonso Rodriguez on 16/12/24.
//

import SwiftUI

struct GameOverModal: View {
    let score: Int
    let restartAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.red)

            Text("Your Score: \(score)")
                .font(.title2)

            Button(action: {
                restartAction() // Ejecuta la acción inmediatamente
            }) {
                Text("Reiniciar")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Button(action: {
                // Acción de compartir (placeholder)
            }) {
                Text("Compartir Score")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
    GameOverModal(score: 30, restartAction: {
        print("Reiniciar juego")
    })
}
