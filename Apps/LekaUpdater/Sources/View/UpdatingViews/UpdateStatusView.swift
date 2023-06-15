// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct UpdateStatusView: View {

    private enum UpdateStatus {
        case sendingFile
        case rebootingRobot
        case updateFinished
    }

    @State private var updatingStatus: UpdateStatus = .sendingFile

    private var stepNumber: Int {
        switch updatingStatus {
            case .sendingFile:
                return 1
            case .rebootingRobot:
                return 2
            case .updateFinished:
                return 3
        }
    }

    var body: some View {
        VStack {
            VStack {
                switch updatingStatus {
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

            Text("Étape \(stepNumber)/3")
                .font(.title)
                .bold()
                .monospacedDigit()
                .padding()

            VStack {
                switch updatingStatus {
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

        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Leka Updater")
                        .font(.title2)
                        .bold()
                    Text("L'application pour mettre à jour vos robots Leka !")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("[DEBUG] Switch views", action: switchView)
            }  // TODO(@yann): remove when debug is over
        }
    }

    func switchView() {
        switch updatingStatus {
            case .sendingFile:
                updatingStatus = .rebootingRobot
            case .rebootingRobot:
                updatingStatus = .updateFinished
            case .updateFinished:
                updatingStatus = .sendingFile
        }
    }

}

struct UpdatingStatusView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UpdateStatusView()
        }
    }
}
