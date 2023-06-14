// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

class UpdateStatusDemoViewModel: ObservableObject {
    private var robot: DummyRobotModel
    private var updateProcessController: UpdateProcessController

    @Published public var state = ""
    @Published public var error: String = ""

    private var cancellables: Set<AnyCancellable> = []

    init(robot: DummyRobotModel) {
        self.robot = robot
        self.updateProcessController = UpdateProcessController(robot: robot)

        subscribeToStateUpdate()
    }

    public func startUpdate() {
        updateProcessController.startUpdate()
    }

    private func subscribeToStateUpdate() {
        self.updateProcessController.currentState
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        self.state = "Votre robot est maintenant à jour!"
                    case .failure(let error):
                        self.state = "Oops, something wrong happened"

                        switch error {
                            case .updateProcessNotAvailable:
                                self.error = "ERROR, this robot cannot be update"
                            default:
                                self.error = "ERROR, unknown"
                        }
                }
            } receiveValue: { state in
                switch state {
                    case .initial:
                        self.state = "initialization"
                }
            }
            .store(in: &cancellables)
    }
}

struct UpdateStatusDemoView: View {
    @StateObject private var viewModel: UpdateStatusDemoViewModel

    init(robot: DummyRobotModel) {
        self._viewModel = StateObject(wrappedValue: UpdateStatusDemoViewModel(robot: robot))
    }

    var body: some View {
        VStack {
            Text("Update Status Demo")
                .font(.largeTitle)
                .padding(.top)

            Divider()
            Spacer()

            VStack {
                VStack {
                    Text("User state is: \(viewModel.state)")
                        .font(.title2)
                        .bold()

                    Button("Start Update", action: viewModel.startUpdate)

                    Text("Error: \(viewModel.error)")
                        .foregroundColor(.red)
                        .opacity(viewModel.error.isEmpty ? 0.0 : 1.0)
                }
                .padding()
            }

            Spacer()
        }
    }
}

struct UpdateStatusDemoView_Previews: PreviewProvider {
    @StateObject static var connectedRobot = DummyRobotModel()

    static var previews: some View {
        UpdateStatusDemoView(robot: connectedRobot)
    }
}
