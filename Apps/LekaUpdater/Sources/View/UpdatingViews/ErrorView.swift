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
        VStack {
            Text(errorDescription)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)

            Text(errorInstruction)
                .multilineTextAlignment(.center)
                .padding()

            HStack {
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
                .padding(.leading)
            }
            .shadow(radius: 3, y: 4)
            .padding()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {

    @State static var isConnectionViewPresented = false

    static let errorDescription = "Erreur inconnue"
    static let errorActionRequired = "Contacter le support technique"

    static var previews: some View {
        VStack {
            ErrorIllustration()
                .frame(height: 250)
                .padding(.bottom)
                .padding(.bottom)

            Text("Une erreur s'est produite")
                .font(.title)
                .bold()
                .monospacedDigit()
                .padding()

            VStack {
                ErrorContentView(
                    errorDescription: errorDescription, errorInstruction: errorActionRequired,
                    isConnectionViewPresented: $isConnectionViewPresented)
                Spacer()
            }
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .frame(maxWidth: .infinity, maxHeight: 250)
        }
    }
}
