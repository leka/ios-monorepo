// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct UpdateStatusView: View {
    @StateObject private var viewModel: UpdateStatusViewModel

    init(robotManager: RobotManager) {
        self._viewModel = StateObject(wrappedValue: UpdateStatusViewModel(robotManager: robotManager))
    }

    var body: some View {
        VStack {
            Spacer()
            Spacer()

            VStack {
                switch viewModel.updatingStatus {
                    case .sendingFile:
                        SendingFileIllustration()
                    case .rebootingRobot:
                        RebootingIllustration()
                    case .updateFinished:
                        UpdateFinishedIllustration()
                }
            }
            .frame(height: 250)
            .padding(.bottom)
            .padding(.bottom)

            Text("Étape \(viewModel.stepNumber)/3")
                .font(.title)
                .bold()
                .monospacedDigit()
                .padding()

            VStack {
                switch viewModel.updatingStatus {
                    case .sendingFile:
                        SendingFileContentView()
                    case .rebootingRobot:
                        RebootingContentView()
                    case .updateFinished:
                        UpdateFinishedContentView()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 250)

            Spacer()

            LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(height: 70)
                .padding(35)

        }
        .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
        .onAppear(perform: viewModel.startUpdate)
        .navigationBarBackButtonHidden()
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
                Button("[DEBUG] Switch views", action: switchView)
            }  // TODO(@yann): remove when debug is over
        }
    }

    func switchView() {
        switch viewModel.updatingStatus {
            case .sendingFile:
                viewModel.updatingStatus = .rebootingRobot
            case .rebootingRobot:
                viewModel.updatingStatus = .updateFinished
            case .updateFinished:
                viewModel.updatingStatus = .sendingFile
        }
    }

}

struct UpdatingStatusView_Previews: PreviewProvider {
    static var robotManager = RobotManager()
    static var previews: some View {
        NavigationStack {
            UpdateStatusView(robotManager: robotManager)
        }
    }
}
