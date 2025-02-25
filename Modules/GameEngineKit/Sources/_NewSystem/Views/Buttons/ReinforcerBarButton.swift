// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

struct ReinforcerBarButton: View {
    // MARK: Lifecycle

    init(onReinforcerTriggerCallback: @escaping (() -> Void) = {}) {
        self.onReinforcerTriggerCallback = onReinforcerTriggerCallback
    }

    // MARK: Internal

    var onReinforcerTriggerCallback: () -> Void

    var body: some View {
        HStack {
            ForEach(Robot.Reinforcer.allCases, id: \.self) { reinforcer in
                reinforcer.icon()
                    .resizable()
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        self.onReinforcerTriggerCallback()
                        Robot.shared.run(reinforcer)
                    }
            }
        }
        .padding()
        .background(self.backgroundColor)
        .clipShape(Capsule())
        .shadow(radius: 1)
    }

    // MARK: Private

    private let backgroundColor: Color = .init(light: UIColor.white, dark: UIColor.systemGray5)
}

#Preview {
    ReinforcerBarButton()
}
