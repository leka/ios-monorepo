// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

@Observable
public class ConnectedRobotInformationViewModel {
    // MARK: Lifecycle

    public init(robot: Robot = .shared) {
        self.robot = robot
        self.getRobotInformation()
    }

    // MARK: Public

    public private(set) var isNotConnected: Bool = true

    public private(set) var name: String = "(n/a)"
    public private(set) var serialNumber: String = "(n/a)"
    public private(set) var osVersion: String = "(n/a)"
    public private(set) var battery: Int = 0
    public private(set) var isCharging: Bool = false
    public private(set) var isConnected: Bool = false

    public func setName(_ name: String) {
        self.name = name
    }

    public func setSerialNumber(_ serialNumber: String) {
        self.serialNumber = serialNumber
    }

    public func setOSVersion(_ osVersion: String) {
        self.osVersion = osVersion
    }

    public func setBattery(_ battery: Int) {
        self.battery = battery
    }

    public func setIsCharging(_ charging: Bool) {
        self.isCharging = charging
    }

    public func setIsConnected(_ connected: Bool) {
        self.isConnected = connected
        self.isNotConnected = !connected
    }

    // MARK: Internal

    @ObservationIgnored let robot: Robot

    // MARK: Private

    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []

    private func getRobotInformation() {
        self.robot.isConnected
            .receive(on: DispatchQueue.main)
            .sink { isConnected in
                self.setIsConnected(isConnected)
                guard self.isNotConnected else { return }
                self.setName("(not connected)")
                self.setSerialNumber("")
                self.setOSVersion("")
                self.setBattery(0)
                self.setIsCharging(false)
            }
            .store(in: &self.cancellables)

        self.robot.name
            .receive(on: DispatchQueue.main)
            .sink {
                self.setName($0)
            }
            .store(in: &self.cancellables)

        self.robot.osVersion
            .receive(on: DispatchQueue.main)
            .sink {
                if let version = $0 {
                    self.setOSVersion("\(version.major).\(version.minor)")
                } else {
                    self.setOSVersion("(n/a)")
                }
            }
            .store(in: &self.cancellables)

        self.robot.battery
            .receive(on: DispatchQueue.main)
            .sink {
                self.setBattery($0)
            }
            .store(in: &self.cancellables)

        self.robot.isCharging
            .receive(on: DispatchQueue.main)
            .sink {
                self.setIsCharging($0)
            }
            .store(in: &self.cancellables)

        self.robot.serialNumber
            .receive(on: DispatchQueue.main)
            .sink {
                self.setSerialNumber($0)
            }
            .store(in: &self.cancellables)
    }
}
