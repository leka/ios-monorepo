// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ErrorIllustration: View {
    var body: some View {
        Image(systemName: "exclamationmark.octagon.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.red)
    }
}

struct ErrorContentView: View {
    @Environment(\.dismiss) var dismiss

    public let errorDescription: String
    public let errorInstruction: String

    @Binding var isConnectionViewPresented: Bool

    var body: some View {
        VStack(spacing: 15) {
            Text(errorDescription)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)

            Text(errorInstruction)
                .multilineTextAlignment(.center)

            Button {
                dismiss()
                isConnectionViewPresented = true
            } label: {
                Text("Revenir à la page de connexion")
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .background(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                    .cornerRadius(10)
            }
            .buttonStyle(.plain)
            .padding(.top)
            .shadow(radius: 3, y: 4)

        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    @State static var isConnectionViewPresented = false

    static let errorDescription = "Erreur inconnue"
    static let errorActionRequired = "Contacter le support technique"

    static var previews: some View {
        VStack(spacing: 40) {
            ErrorIllustration()
                .frame(height: 250)

            Text("Une erreur s'est produite")
                .font(.title)
                .bold()
                .monospacedDigit()

            ErrorContentView(
                errorDescription: errorDescription, errorInstruction: errorActionRequired,
                isConnectionViewPresented: $isConnectionViewPresented
            )
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
        }
    }
}
