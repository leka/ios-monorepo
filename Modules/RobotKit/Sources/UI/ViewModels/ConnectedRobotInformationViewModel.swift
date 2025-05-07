// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Observation
import SwiftUI

@Observable
public class ConnectedRobotInformationViewModel {
    // MARK: Lifecycle

    public init(robot: Robot = .shared) {
        self.robot = robot
        self.getRobotInformation()
    }

    // MARK: Public

    public var isNotConnected: Bool = true

    public var name: String = "(n/a)"
    public var serialNumber: String = "(n/a)"
    public var osVersion: String = "(n/a)"

    public var battery: Int = 0
    public var isCharging: Bool = false

    public var isConnected: Bool = false {
        didSet {
            self.isNotConnected = !self.isConnected
        }
    }

    // MARK: Internal

    @ObservationIgnored let robot: Robot

    // MARK: Private

    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []

    private func getRobotInformation() {
        self.robot.isConnected
            .receive(on: DispatchQueue.main)
            .sink { isConnected in
                self.isConnected = isConnected
                guard self.isNotConnected else { return }
                self.name = "(not connected)"
                self.serialNumber = ""
                self.osVersion = ""
                self.battery = 0
                self.isCharging = false
            }
            .store(in: &self.cancellables)

        self.robot.name
            .receive(on: DispatchQueue.main)
            .sink {
                self.name = $0
            }
            .store(in: &self.cancellables)

        self.robot.osVersion
            .receive(on: DispatchQueue.main)
            .sink {
                if let version = $0 {
                    self.osVersion = "\(version.major).\(version.minor)"
                } else {
                    self.osVersion = "(n/a)"
                }
            }
            .store(in: &self.cancellables)

        self.robot.battery
            .receive(on: DispatchQueue.main)
            .sink {
                self.battery = $0
            }
            .store(in: &self.cancellables)

        self.robot.isCharging
            .receive(on: DispatchQueue.main)
            .sink {
                self.isCharging = $0
            }
            .store(in: &self.cancellables)

        self.robot.serialNumber
            .receive(on: DispatchQueue.main)
            .sink {
                self.serialNumber = $0
            }
            .store(in: &self.cancellables)
    }
}
