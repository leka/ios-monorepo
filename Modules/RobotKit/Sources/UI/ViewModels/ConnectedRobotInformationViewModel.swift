// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class ConnectedRobotInformationViewModel: ObservableObject {

    @Published public var isConnected: Bool = false {
        didSet {
            self.isNotConnected = !isConnected
        }
    }

    @Published public var isNotConnected: Bool = true

    @Published public var name: String = "(n/a)"
    @Published public var serialNumber: String = "(n/a)"
    @Published public var osVersion: String = "(n/a)"

    @Published public var battery: Int = 0
    @Published public var isCharging: Bool = false

    let robot = Robot.shared

    private var cancellables: Set<AnyCancellable> = []

    public init() {
        getRobotInformation()
    }

    private func getRobotInformation() {
        robot.isConnected
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
            .store(in: &cancellables)

        robot.name
            .receive(on: DispatchQueue.main)
            .sink {
                self.name = $0
            }
            .store(in: &cancellables)

        robot.osVersion
            .receive(on: DispatchQueue.main)
            .sink {
                self.osVersion = $0?.description ?? "(n/a)"
            }
            .store(in: &cancellables)

        robot.battery
            .receive(on: DispatchQueue.main)
            .sink {
                self.battery = $0
            }
            .store(in: &cancellables)

        robot.isCharging
            .receive(on: DispatchQueue.main)
            .sink {
                self.isCharging = $0
            }
            .store(in: &cancellables)

        robot.serialNumber
            .receive(on: DispatchQueue.main)
            .sink {
                self.serialNumber = $0
            }
            .store(in: &cancellables)
    }

}
