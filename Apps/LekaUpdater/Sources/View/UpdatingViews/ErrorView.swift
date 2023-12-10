// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ErrorIllustration

struct ErrorIllustration: View {
    var body: some View {
        Image(systemName: "exclamationmark.octagon.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.red)
    }
}

// MARK: - ErrorContentView

struct ErrorContentView: View {
    @Environment(\.dismiss) var dismiss

    public let errorDescription: String
    public let errorInstruction: String

    @Binding var isConnectionViewPresented: Bool

    var body: some View {
        VStack(spacing: 15) {
            Text(self.errorDescription)
                .font(.title2)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)

            Text(self.errorInstruction)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)

            Button {
                self.dismiss()
                self.isConnectionViewPresented = true
            } label: {
                Text(l10n.update.errorBackButtonTitle)
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

// MARK: - ErrorView_Previews

struct ErrorView_Previews: PreviewProvider {
    @State static var isConnectionViewPresented = false

    static let errorDescription = l10n.update.errorDescription
    static let errorActionRequired = l10n.update.errorCallToAction

    static var previews: some View {
        VStack(spacing: 40) {
            ErrorIllustration()
                .frame(height: 250)

            Text(l10n.update.errorTitle)
                .font(.title)
                .bold()
                .monospacedDigit()

            ErrorContentView(
                errorDescription: String(errorDescription.characters),
                errorInstruction: String(errorActionRequired.characters),
                isConnectionViewPresented: $isConnectionViewPresented
            )
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
        }
    }
}
