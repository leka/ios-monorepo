// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

class UpdateStatusDemoViewModel: ObservableObject {
    private var updateProcessController: UpdateProcessController

    @Published public var state = ""
    @Published public var error: String = ""

    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.updateProcessController = UpdateProcessController()

        subscribeToStateUpdates()
    }

    public func startUpdate() {
        updateProcessController.startUpdate()
    }

    private func subscribeToStateUpdates() {
        self.updateProcessController.currentStage
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        self.state = "Votre robot est maintenant à jour!"
                    case let .failure(error):
                        self.state = "Oops, something wrong happened"

                        switch error {
                            case .updateProcessNotAvailable:
                                self.error = "ERROR, this robot cannot be update"
                            case .failedToLoadFile:
                                self.error = "ERROR, please reinstall the app"
                            case .robotNotUpToDate:
                                self.error = "ERROR, please try again"
                            default:
                                self.error = "ERROR, unknown"
                        }
                }
            } receiveValue: { state in
                switch state {
                    case .initial:
                        self.state = "initialization"
                    case .sendingUpdate:
                        self.state = "sending update"
                    case .installingUpdate:
                        self.state = "installing update"
                }
            }
            .store(in: &cancellables)
    }
}

struct UpdateStatusDemoView: View {
    @StateObject private var viewModel = UpdateStatusDemoViewModel()

    var body: some View {
        VStack {
            Text(verbatim: "Update Status Demo")
                .font(.largeTitle)
                .padding(.top)

            Divider()
            Spacer()

            VStack {
                VStack {
                    Text(verbatim: "User state is: \(viewModel.state)")
                        .font(.title2)
                        .bold()

                    Button(action: viewModel.startUpdate) {
                        Text(verbatim: "Start Update")
                    }

                    Text(verbatim: "Error: \(viewModel.error)")
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
    static var previews: some View {
        UpdateStatusDemoView()
    }
}
