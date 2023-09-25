// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

class ConnectedRobotInformationViewModel: ObservableObject {

    public var name: String = ""
    public var serialNumber: String = ""
    public var osVersion: String = ""

    @State var battery: Int = 0
    @State var charging: Bool = false

    init(name: String, serialNumber: String, osVersion: String, battery: Int, charging: Bool) {
        self.name = name
        self.serialNumber = serialNumber
        self.osVersion = osVersion
        self.battery = battery
        self.charging = charging
    }

    static var mockConnected: ConnectedRobotInformationViewModel {
        .init(
            name: "Mock Robot",
            serialNumber: "LK-22XXMCKRBT",
            osVersion: "1.4.0",
            battery: 52,
            charging: false
        )
    }

    // TODO(@ladislas): implement connected/disconnected logic
    static var mockDisconnected: ConnectedRobotInformationViewModel {
        .init(
            name: "n/a",
            serialNumber: "n/a",
            osVersion: "n/a",
            battery: 0,
            charging: false
        )
    }

}
