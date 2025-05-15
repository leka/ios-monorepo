// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ErrorIllustration

struct ErrorIllustration: View {
    var body: some View {
        LekaUpdaterAsset.Assets.updateError.swiftUIImage
            .resizable()
            .scaledToFit()
    }
}

// MARK: - ErrorContentView

struct ErrorContentView: View {
    // MARK: Lifecycle

    init(
        error: UpdateProcessError,
        isConnectionViewPresented: Binding<Bool>,
        isUpdateStatusViewPresented: Binding<Bool>
    ) {
        self.error = error
        self._isConnectionViewPresented = isConnectionViewPresented
        self._isUpdateStatusViewPresented = isUpdateStatusViewPresented
        switch error {
            case .failedToLoadFile:
                self.errorDescription = String(l10n.update.error.failedToLoadFileDescription.characters)
                self.errorInstructions = String(
                    l10n.update.error.failedToLoadFileInstructions.characters)
                self.errorButtonLabel = String(l10n.update.error.checkUpdateButtonLabel.characters)

            case .robotNotUpToDate:
                self.errorDescription = String(l10n.update.error.robotNotUpToDateDescription.characters)
                self.errorInstructions = String(
                    l10n.update.error.robotNotUpToDateInstructions.characters)
                self.errorButtonLabel = String(l10n.update.error.backToConnectionButtonLabel.characters)

            case .updateProcessNotAvailable:
                self.errorDescription = String(
                    l10n.update.error.updateProcessNotAvailableDescription.characters)
                self.errorInstructions = String(
                    l10n.update.error.updateProcessNotAvailableInstructions.characters)
                self.errorButtonLabel = String(l10n.update.error.closeButtonLabel.characters)

            case .robotUnexpectedDisconnection:
                self.errorDescription = String(
                    l10n.update.error.robotUnexpectedDisconnectionDescription.characters)
                self.errorInstructions = String(
                    l10n.update.error.robotUnexpectedDisconnectionInstructions.characters)
                self.errorButtonLabel = String(l10n.update.error.closeButtonLabel.characters)

            default:
                self.errorDescription = String(l10n.update.error.unknownErrorDescription.characters)
                self.errorInstructions = String(l10n.update.error.unknownErrorInstructions.characters)
                self.errorButtonLabel = String(l10n.update.error.closeButtonLabel.characters)
        }
    }

    // MARK: Internal

    @Binding var isConnectionViewPresented: Bool
    @Binding var isUpdateStatusViewPresented: Bool

    let error: UpdateProcessError

    var body: some View {
        VStack(spacing: 15) {
            Text(self.errorInstructions)
                .font(.title2)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)

            Text(self.errorDescription)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)

            Button {
                if self.error == .failedToLoadFile, let url = URL(string: "https://apps.apple.com/app/leka/id6446940339") {
                    UIApplication.shared.open(url)
                }
                self.isUpdateStatusViewPresented = false
                self.isConnectionViewPresented = self.error == .robotNotUpToDate
            } label: {
                Text(self.errorButtonLabel)
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

    // MARK: Private

    private let errorDescription: String
    private let errorInstructions: String
    private let errorButtonLabel: String
}

// MARK: - ErrorView_Previews

#Preview {
    VStack(spacing: 40) {
        ErrorIllustration()
            .frame(height: 250)

        Text(l10n.update.errorTitle)
            .font(.title)
            .bold()
            .monospacedDigit()

        ErrorContentView(
            error: .unknown,
            isConnectionViewPresented: .constant(false),
            isUpdateStatusViewPresented: .constant(true)
        )
        .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
    }
}
