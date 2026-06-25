// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import DeviceKit
import RobotKit
import SwiftUI
import UtilsKit

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
                    .frame(width: self.reinforcerSize, height: self.reinforcerSize)
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
    private let reinforcerSize: CGFloat = Device.current.getDeviceSize() == .small ? 80 : 100
}

#Preview {
    ReinforcerBarButton()
}
