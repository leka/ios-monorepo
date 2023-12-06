// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - UpdateStatusView

struct UpdateStatusView: View {
    @StateObject private var viewModel = UpdateStatusViewModel()

    @Binding var isConnectionViewPresented: Bool

    var body: some View {
        NavigationStack {
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
                        case .error:
                            ErrorIllustration()
                    }
                }
                .frame(height: 250)
                .padding(.bottom)
                .padding(.bottom)

                if viewModel.updatingStatus == .error {
                    Text(l10n.update.errorTitle)
                        .font(.title)
                        .bold()
                        .padding()
                } else {
                    Text(l10n.update.stepNumber("\(viewModel.stepNumber)/3"))
                        .font(.title)
                        .bold()
                        .monospacedDigit()
                        .padding()
                        .alert(isPresented: $viewModel.showAlert) {
                            Alert(
                                title: Text(l10n.update.alert.robotNotInChargeTitle),
                                message: Text(l10n.update.alert.robotNotInChargeMessage)
                            )
                        }
                }

                VStack {
                    switch viewModel.updatingStatus {
                        case .sendingFile:
                            SendingFileContentView(progress: $viewModel.sendingFileProgression)
                        case .rebootingRobot:
                            RebootingContentView()
                        case .updateFinished:
                            UpdateFinishedContentView(isConnectionViewPresented: $isConnectionViewPresented)
                        case .error:
                            ErrorContentView(
                                errorDescription: viewModel.errorDescription,
                                errorInstruction: viewModel.errorInstructions,
                                isConnectionViewPresented: $isConnectionViewPresented
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
            .onAppear(perform: viewModel.startUpdate)
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
}

// MARK: - UpdatingStatusView_Previews

struct UpdatingStatusView_Previews: PreviewProvider {
    @State static var isConnectionViewPresented = false

    static var previews: some View {
        UpdateStatusView(isConnectionViewPresented: $isConnectionViewPresented)
            .environment(\.locale, .init(identifier: "en"))
        UpdateStatusView(isConnectionViewPresented: $isConnectionViewPresented)
            .environment(\.locale, .init(identifier: "fr"))
    }
}
