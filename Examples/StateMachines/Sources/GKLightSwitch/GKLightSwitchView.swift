//
//  GameplayKitView.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 23/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Combine
import SwiftUI

class LightSwitchViewModel: ObservableObject {
    @Published public var circleColor: Color = .gray
    @Published public var status: String = "idle"

    private var cancellables: Set<AnyCancellable> = []

    private let switchController: SwitchController
    private let lightController: LightController

    init() {
        self.switchController = SwitchController()
        self.lightController = LightController(switchController: self.switchController)

        subscribeToCountUpdate()
        subscribeToStateUpdate()
    }

    public func pressButton() {
        lightController.press()
    }

    public func turnButton() {
        lightController.turn()
    }

    private func subscribeToCountUpdate() {
        self.switchController.$count
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                guard let self = self else { return }
                self.status = "count = \(count)"
            }
            .store(in: &cancellables)
    }

    private func subscribeToStateUpdate() {
        self.lightController.$currentState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                    case .off:
                        self.circleColor = .gray
                    case .green:
                        self.circleColor = .green
                    case .yellow:
                        self.circleColor = .yellow
                    case .red:
                        self.circleColor = .red
                        self.status = "over heat, turn off"
                }
            }
            .store(in: &cancellables)
    }
}

struct GKLightSwitchView: View {
    @StateObject var viewModel: LightSwitchViewModel = LightSwitchViewModel()

    var body: some View {
        VStack(spacing: 50) {
            Circle()
                .fill(viewModel.circleColor)
                .frame(width: 200)

            Text("Status: \(viewModel.status)")

            HStack(spacing: 50) {
                Button {
                    viewModel.pressButton()
                } label: {
                    Text("Press")
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: 200)
                        .background(.blue)
                        .cornerRadius(10)
                }

                Button {
                    viewModel.turnButton()
                } label: {
                    Text("Turn")
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: 200)
                        .background(.green)
                        .cornerRadius(10)
                }

            }
        }

    }
}

struct GKLightSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        GKLightSwitchView()
    }
}
