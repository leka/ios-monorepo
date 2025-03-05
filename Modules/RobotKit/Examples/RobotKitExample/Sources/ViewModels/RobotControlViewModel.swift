// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

class RobotControlViewModel: ObservableObject {
    // MARK: Lifecycle

    init(robot: Robot) {
        self.robot = robot
        self.robot.onMagicCard()
            .receive(on: DispatchQueue.main)
            .sink {
                self.magicCard = $0
                self.magicCardImage = {
                    switch $0.details {
                        case .none:
                            Image(systemName: "cross")
                        case .emergency_stop:
                            Image(systemName: "exclamationmark.octagon")
                        case .dice_roll:
                            Image(systemName: "dice")
                        default:
                            Image(systemName: "photo")
                    }
                }($0)
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var magicCard: MagicCard = .init(.none)
    @Published var magicCardImage: Image = .init(systemName: "photo")

    // MARK: Private

    private let robot: Robot
    private var cancellables: Set<AnyCancellable> = []
}
