// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

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
                    Text("Une erreur s'est produite")
                        .font(.title)
                        .bold()
                        .padding()
                } else {
                    Text("Étape \(viewModel.stepNumber)/3")
                        .font(.title)
                        .bold()
                        .monospacedDigit()
                        .padding()
                        .alert(isPresented: $viewModel.showAlert) {
                            Alert(
                                title: Text(
                                    """
                                    ⚠️ ATTENTION ⚡
                                    Le robot n'est plus en charge
                                    """
                                ),
                                message: Text(
                                    """
                                    Veuillez reposer Leka sur sa base
                                    et/ou vérifier le branchement
                                    """
                                ))
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
                                errorInstruction: viewModel.errorInstruction,
                                isConnectionViewPresented: $isConnectionViewPresented)
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
    }

    func switchView() {
        switch viewModel.updatingStatus {
            case .sendingFile:
                viewModel.updatingStatus = .rebootingRobot
            case .rebootingRobot:
                viewModel.updatingStatus = .updateFinished
            case .updateFinished:
                viewModel.updatingStatus = .sendingFile
            case .error:
                viewModel.updatingStatus = .error
        }
    }

}

struct UpdatingStatusView_Previews: PreviewProvider {
    @State static var isConnectionViewPresented = false

    static var previews: some View {
        NavigationStack {
            UpdateStatusView(isConnectionViewPresented: $isConnectionViewPresented)
        }
    }
}
