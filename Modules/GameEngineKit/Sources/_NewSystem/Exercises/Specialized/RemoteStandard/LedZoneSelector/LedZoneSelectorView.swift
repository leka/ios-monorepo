// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct LedZoneSelectorView: View {
    // MARK: Internal

    let displayMode: RemoteStandard.DisplayMode

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 300, height: 300)

            VStack {
                Image(systemName: "chevron.up")
                    .foregroundColor(.gray.opacity(0.7))
                Text("Front")
                    .foregroundColor(.gray.opacity(0.7))

                Spacer()
            }
            .padding(20)

            beltSectionButtons
            earsSectionButtons
        }
    }

    // MARK: Private

    private var earsSectionButtons: some View {
        HStack(spacing: 50) {
            switch displayMode {
                case .fullBelt:
                    EarButton(selectedEar: .full(.ears, in: .blue))
                case .twoHalves:
                    EarButton(selectedEar: .earLeft(in: .purple))
                    EarButton(selectedEar: .earRight(in: .green))
                case .fourQuarters:
                    EarButton(selectedEar: .earLeft(in: .orange))
                    EarButton(selectedEar: .earRight(in: .blue))
            }
        }
    }

    private var beltSectionButtons: some View {
        ZStack {
            switch displayMode {
                case .fullBelt:
                    BeltSectionButton(section: .full(.belt, in: .red))
                case .twoHalves:
                    BeltSectionButton(section: .halfLeft(in: .red))
                    BeltSectionButton(section: .halfRight(in: .blue))
                case .fourQuarters:
                    BeltSectionButton(section: .quarterFrontRight(in: .green))
                    BeltSectionButton(section: .quarterBackRight(in: .blue))
                    BeltSectionButton(section: .quarterBackLeft(in: .red))
                    BeltSectionButton(section: .quarterFrontLeft(in: .yellow))
            }
        }
    }
}

#Preview {
    LedZoneSelectorView(displayMode: .fourQuarters)
}
