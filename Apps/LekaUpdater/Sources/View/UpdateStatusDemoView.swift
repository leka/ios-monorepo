// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - UpdateStatusDemoViewModel

@Observable
class UpdateStatusDemoViewModel {
    // MARK: Lifecycle

    init() {
        self.updateProcessController = UpdateProcessController()

        self.subscribeToStateUpdates()
    }

    // MARK: Public

    public var state = ""
    public var error: String = ""

    public func startUpdate() {
        self.updateProcessController.startUpdate()
    }

    // MARK: Private

    private var updateProcessController: UpdateProcessController

    private var cancellables: Set<AnyCancellable> = []

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
            .store(in: &self.cancellables)
    }
}

// MARK: - UpdateStatusDemoView

struct UpdateStatusDemoView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            Text(verbatim: "Update Status Demo")
                .font(.largeTitle)
                .padding(.top)

            Divider()
            Spacer()

            VStack {
                VStack {
                    Text(verbatim: "User state is: \(self.viewModel.state)")
                        .font(.title2)
                        .bold()

                    Button(action: self.viewModel.startUpdate) {
                        Text(verbatim: "Start Update")
                    }

                    Text(verbatim: "Error: \(self.viewModel.error)")
                        .foregroundColor(.red)
                        .opacity(self.viewModel.error.isEmpty ? 0.0 : 1.0)
                }
                .padding()
            }

            Spacer()
        }
    }

    // MARK: Private

    @State private var viewModel = UpdateStatusDemoViewModel()
}

// MARK: - UpdateStatusDemoView_Previews

struct UpdateStatusDemoView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateStatusDemoView()
    }
}
