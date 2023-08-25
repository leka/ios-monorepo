// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

enum HideAndSeekStage {
    case toHide
    case hidden
}

struct HideAndSeekModeButtonLabel: View {
    let text: String
    let color: Color

    init(_ text: String, color: Color) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(.title2)
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .frame(width: 400, height: 50)
            .scaledToFit()
            .background(Capsule().fill(color).shadow(radius: 3))
    }
}

struct HideAndSeekLauncher: View {
    @State private var stage = HideAndSeekStage.toHide

    var body: some View {
        switch stage {
            case .toHide:
                VStack {
                    Text("Appuyer sur **OK** lorsque Leka est caché")
                    Image("hideAndSeek")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 500, height: 500)

                    Button {
                        stage = .hidden
                    } label: {
                        HideAndSeekModeButtonLabel("OK", color: .cyan)
                    }
                }
                .scaledToFill()
                .alertWhenRobotIsNeeded()
            case .hidden:
                HideAndSeekPlayer(stage: $stage)
        }
    }
}

struct HideAndSeekLauncher_Previews: PreviewProvider {
    static var previews: some View {
        HideAndSeekLauncher()
    }
}
