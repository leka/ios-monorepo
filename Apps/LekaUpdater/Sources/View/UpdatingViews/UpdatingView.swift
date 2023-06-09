// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct UpdatingView: View {
    private enum UpdatingStatus {
        case sendingFile
        case rebootingFile
    }

    @State private var updatingStatus: UpdatingStatus = .sendingFile

    var body: some View {
        VStack {
            Spacer()

            switch updatingStatus {
                case .sendingFile:
                    SendingFileView()
                case .rebootingFile:
                    RebootingView()
            }

            Spacer()
            Divider()
            Button("[DEBUG] Switch views", action: switchView)
                .padding()
        }
    }

    func switchView() {
        switch updatingStatus {
            case .sendingFile:
                updatingStatus = .rebootingFile
            case .rebootingFile:
                updatingStatus = .sendingFile
        }
    }
}

struct UpdatingView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatingView()
    }
}
