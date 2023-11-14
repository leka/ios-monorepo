// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

struct ConnectionView: View {
    @StateObject private var viewModel = ConnectionViewModel()

    private let bold15: Font = .system(size: 15, weight: .bold)

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                RobotConnectionView(robotConnectionViewModel: viewModel.robotConnectionViewModel)

                continueButton

                LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                    .padding(35)
            }
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(l10n.main.appName)
                            .font(.title2)
                            .bold()
                        Text(l10n.main.appDescription)
                    }
                    .foregroundColor(.accentColor)
                }
            }
        }
    }

    private var continueButton: some View {
        Button(
            action: {
                dismiss()
            },
            label: {
                HStack {
                    Text(l10n.connection.continueButton)
                    Image(systemName: "arrow.forward.circle")
                }
                .font(bold15)
                .foregroundColor(.white)
                .padding(6)
                .frame(width: 210)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(DesignKitAsset.Colors.lekaGreen.swiftUIColor)
        .disabled(viewModel.continueButtonDisabled)
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
            .environment(\.locale, .init(identifier: "en"))
        ConnectionView()
            .environment(\.locale, .init(identifier: "fr"))
    }
}
