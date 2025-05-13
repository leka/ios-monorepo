// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - UpdateStatusView

struct UpdateStatusView: View {
    @StateObject private var viewModel = UpdateStatusViewModel()

    @Binding var isConnectionViewPresented: Bool
    @Binding var isUpdateStatusViewPresented: Bool

    var body: some View {
        VStack {
            Spacer()
            Spacer()

            VStack {
                switch self.viewModel.updatingStatus {
                    case .sendingFile:
                        SendingFileIllustration()
                    case .rebootingRobot:
                        RebootingIllustration()
                    case .updateFinished:
                        UpdateFinishedIllustration()
                    case .error:
                        ErrorIllustration()
                }
            }
            .frame(height: 250)
            .padding(.bottom)
            .padding(.bottom)

            if self.viewModel.updatingStatus == .error {
                Text(l10n.update.errorTitle)
                    .font(.title)
                    .bold()
                    .padding()
            } else {
                Text(l10n.update.stepNumber("\(self.viewModel.stepNumber)/3"))
                    .font(.title)
                    .bold()
                    .monospacedDigit()
                    .padding()
                    .alert(isPresented: self.$viewModel.showAlert) {
                        Alert(
                            title: Text(l10n.update.alert.robotNotInChargeTitle),
                            message: Text(l10n.update.alert.robotNotInChargeMessage)
                        )
                    }
            }

            VStack {
                switch self.viewModel.updatingStatus {
                    case .sendingFile:
                        SendingFileContentView(progress: self.$viewModel.sendingFileProgression)
                    case .rebootingRobot:
                        RebootingContentView()
                    case .updateFinished:
                        UpdateFinishedContentView(isUpdateStatusViewPresented: self.$isUpdateStatusViewPresented,
                                                  isConnectionViewPresented: self.$isConnectionViewPresented)
                    case .error:
                        ErrorContentView(
                            errorDescription: self.viewModel.errorDescription,
                            errorInstruction: self.viewModel.errorInstructions,
                            isConnectionViewPresented: self.$isConnectionViewPresented,
                            isUpdateStatusViewPresented: self.$isUpdateStatusViewPresented
                        )
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
        .background(.lkBackground)
        .onAppear(perform: self.viewModel.startUpdate)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(l10n.main.appName)
                        .font(.title2)
                        .bold()
                    Text(l10n.main.appDescription)
                }
                .foregroundColor(.lkNavigationTitle)
            }
        }
    }
}

#Preview {
    NavigationStack {
        UpdateStatusView(isConnectionViewPresented: .constant(false), isUpdateStatusViewPresented: .constant(true))
    }
}
