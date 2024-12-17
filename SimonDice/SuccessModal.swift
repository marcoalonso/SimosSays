//
//  SuccessModal.swift
//  SimonDice
//
//  Created by Marco Alonso Rodriguez on 16/12/24.
//

import SwiftUI

struct SuccessModal: View {
    let level: Int
    let nextAction: () -> Void

    var body: some View {
        ZStack {
            Color.white.opacity(0.9) // Fondo semi-transparente
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("¡Correcto!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Nivel \(level)")
                    .font(.title)
                    .foregroundColor(.black)
                
                Button(action: nextAction) {
                    Text("Siguiente Nivel")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.green)
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
    SuccessModal(level: 1, nextAction: {
        print("Reiniciar juego")
    })
}
