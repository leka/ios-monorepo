// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ConnectionView: View {
    @StateObject private var viewModel = ConnectionViewModel()

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                RobotConnectionView(robotConnectionViewModel: viewModel.robotConnectionViewModel)

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
                        Text("Leka Updater")
                            .font(.title2)
                            .bold()
                        Text("L'application pour mettre à jour vos robots Leka !")
                    }
                    .foregroundColor(.accentColor)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Text("Continuer")
                            Image(systemName: "chevron.forward")
                        }
                    }
                    .disabled(viewModel.continueButtonDisabled)
                }
            }
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
