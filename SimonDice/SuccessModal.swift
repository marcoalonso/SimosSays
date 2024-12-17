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
        VStack(spacing: 20) {
            Text("¡Correcto!") // Mensaje de éxito
                .font(.title)
                .bold()

            Text("Nivel \(level)") // Nivel alcanzado
                .font(.largeTitle)
                .foregroundColor(.blue)
                .scaleEffect(1.1)
                .shadow(radius: 5)

            Button(action: {
                nextAction() // Se ejecuta inmediatamente sin transiciones visibles
            }) {
                Text("Siguiente Nivel")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
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
    SuccessModal(level: 1, nextAction: {
        print("Reiniciar juego")
    })
}
