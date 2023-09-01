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

    public let errorDescription: String
    public let errorInstruction: String

    var body: some View {
        VStack {
            Text(errorDescription)
                .font(.title2)
                .bold()

            Text(errorInstruction)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {

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
                ErrorContentView(errorDescription: errorDescription, errorInstruction: errorActionRequired)
                Spacer()
            }
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .frame(maxWidth: .infinity, maxHeight: 250)
        }
    }
}
