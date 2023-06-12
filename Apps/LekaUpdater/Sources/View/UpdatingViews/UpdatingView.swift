// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct UpdatingView: View {
    private enum UpdateStatus {
        case sendingFile
        case rebootingRobot
    }

    @State private var updatingStatus: UpdateStatus = .sendingFile

    private var stepNumber: Int {
        guard updatingStatus == .sendingFile else {
            return 2
        }
        return 1
    }

    var body: some View {
        VStack {
            LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                .resizable()
                .scaledToFit()
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
                        SendingFileView()
                    case .rebootingRobot:
                        RebootingView()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 250)

        }
        .toolbar {  // TODO(@yann): remove when debug is over
            Button("[DEBUG] Switch views", action: switchView)
        }
    }

    func switchView() {
        switch updatingStatus {
            case .sendingFile:
                updatingStatus = .rebootingRobot
            case .rebootingRobot:
                updatingStatus = .sendingFile
        }
    }
}

struct UpdatingView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatingView()
    }
}
