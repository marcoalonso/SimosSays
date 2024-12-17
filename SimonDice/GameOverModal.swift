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
        ZStack {
            Color.black.opacity(0.7) // Fondo semi-transparente
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("¡Game Over!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
                
                Text("Tu puntaje: \(score)")
                    .font(.title)
                    .foregroundColor(.white)
                
                Button(action: restartAction) {
                    Text("Reiniciar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .transition(.opacity)
        .animation(.easeInOut, value: 1)
    }
}

#Preview {
    GameOverModal(score: 30, restartAction: {
        print("Reiniciar juego")
    })
}
