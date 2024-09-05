// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class ConnectedRobotInformationViewModel: ObservableObject {
    // MARK: Lifecycle

    public init() {
        self.getRobotInformation()
    }

    // MARK: Public

    @Published public var isNotConnected: Bool = true

    @Published public var name: String = "(n/a)"
    @Published public var serialNumber: String = "(n/a)"
    @Published public var osVersion: String = "(n/a)"

    @Published public var battery: Int = 0
    @Published public var isCharging: Bool = false

    @Published public var isConnected: Bool = false {
        didSet {
            self.isNotConnected = !self.isConnected
        }
    }

    // MARK: Internal

    let robot = Robot.shared

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []

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
