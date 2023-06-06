//
//  Leka_1_0_0_ViewDemo.swift
//  LekaUpdater
//
//  Created by Yann LOCATELLI on 05/06/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Combine
import SwiftUI

class RobotController: Leka_1_0_0_RobotController {
    var raiseEvent: ((Leka_1_0_0_Event) -> Void)?

    func loadUpdateFile() {
        print("Loading update file...")

        Task {
            try await Task<Never, Never>.sleep(seconds: 1)
            raiseEvent?(.fileLoaded)
        }
    }

    func setBLEDestinationPath() {
        print("Setting BLE Destination Path...")

        Task {
            try await Task<Never, Never>.sleep(seconds: 0.1)
            raiseEvent?(.destinationPathSet)
        }
    }

    func sendFile() {
        print("Sending file...")

        Task {
            try await Task<Never, Never>.sleep(seconds: 10)
            raiseEvent?(.fileSent)
        }
    }

    func setBLEMajorMinorRevisionApply() {
        print("Setting BLE Major Minor Revision Apply...")
    }

    func isRobotUpToDate() -> Bool {
        return false
    }
}

class Leka_1_0_0_ViewModelDemo: ObservableObject {
    @Published public var state: String = "initial"
    @Published public var error: String = ""

    private var cancellables: Set<AnyCancellable> = []

    private var robotController: RobotController
    private var controller: Leka_1_0_0_Controller

    init() {
        self.robotController = RobotController()
        self.controller = Leka_1_0_0_Controller(robotController: robotController)

        self.robotController.raiseEvent = self.controller.raiseEvent

        subscribeToStateUpdate()
        subscribeToErrorUpdate()
    }

    public func startUpdate() {
        self.controller.startUpdate()
    }

    public func robotDisconnection() {
        self.controller.raiseEvent(event: .robotDisconnected)
    }

    public func robotDetected() {
        self.controller.raiseEvent(event: .robotDetected)
    }

    private func subscribeToStateUpdate() {
        self.controller.$currentState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }

                switch state {
                    case .initial:
                        self.state = "initial"
                    case .loadingUpdateFile:
                        self.state = "loading update file"
                    case .settingDestinationPath:
                        self.state = "setting destination path"
                    case .sendingFile:
                        self.state = "sending file"
                    case .applyingUpdate:
                        self.state = "applying update"
                    case .waitingRobotToReboot:
                        self.state = "waiting robot to reboot"
                    case .final:
                        self.state = "final"
                }
            }
            .store(in: &cancellables)
    }

    private func subscribeToErrorUpdate() {
        self.controller.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }

                switch error {
                    case .failedToLoadFile:
                        self.error = "failed to load file"
                    case .robotNotUpToDate:
                        self.error = "robot not up to date"
                    case .none:
                        self.error = ""
                }
            }
            .store(in: &cancellables)
    }
}

struct Leka_1_0_0_ViewDemo: View {
    @StateObject private var viewModel = Leka_1_0_0_ViewModelDemo()

    var body: some View {
        VStack {
            Text("Current state is \(viewModel.state)")

            Button("Start update") {
                viewModel.startUpdate()
            }

            HStack {
                Button("Robot disconnection") {
                    viewModel.robotDisconnection()
                }
                Button("Robot detected") {
                    viewModel.robotDetected()
                }
            }

            Text("Error: \(viewModel.error)")
                .foregroundColor(.red)
                .opacity(viewModel.error.isEmpty ? 0.0 : 1.0)
        }
    }
}

struct Leka_1_0_0_ViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        Leka_1_0_0_ViewDemo()
    }
}
