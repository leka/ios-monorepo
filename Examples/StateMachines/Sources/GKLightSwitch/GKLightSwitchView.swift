//
//  GameplayKitView.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 23/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

class LightSwitchViewModel: ObservableObject {
    @Published public var circleColor: Color = .gray

    private let stateMachine: LightStateMachine = LightStateMachine()

    public func pressButton() {
        stateMachine.process(event: .pressed)
        getCircleColor()
    }

    public func turnButton() {
        stateMachine.process(event: .turned)
        getCircleColor()
    }

    private func getCircleColor() {
        switch stateMachine.state {
            case .off:
                circleColor = .gray
            case .green:
                circleColor = .green
            case .red:
                circleColor = .red
        }
    }
}

struct GKLightSwitchView: View {
    @StateObject var viewModel: LightSwitchViewModel = LightSwitchViewModel()

    var body: some View {
        VStack(spacing: 50) {
            Circle()
                .fill(viewModel.circleColor)
                .frame(width: 200)
            HStack(spacing: 50) {
                Button {
                    viewModel.pressButton()
                } label: {
                    Text("Press me")
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: 200)
                        .background(.blue)
                        .cornerRadius(10)
                }

                Button {
                    viewModel.turnButton()
                } label: {
                    Text("Turn me")
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
