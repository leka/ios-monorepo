// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

// swiftlint:disable nesting
extension HideAndSeekView {
    struct Player: View {
        // MARK: Lifecycle

        init(
            stage: Binding<HideAndSeekStage>, textSubInstructions: String, textButtonRobotFound: String,
            shared: ExerciseSharedData? = nil
        ) {
            _stage = stage
            self.textSubInstructions = textSubInstructions
            self.textButtonRobotFound = textButtonRobotFound

            self.exercicesSharedData = shared ?? ExerciseSharedData()
            self.exercicesSharedData.state = .playing
        }

        // MARK: Internal

        enum Stimulation: String, CaseIterable {
            case light
            case motion

            // MARK: Public

            public func icon() -> Image {
                switch self {
                    case .light:
                        GameEngineKitAsset.Exercises.HideAndSeek.iconStimulationLight.swiftUIImage
                    case .motion:
                        GameEngineKitAsset.Exercises.HideAndSeek.iconStimulationMotion.swiftUIImage
                }
            }
        }

        @Binding var stage: HideAndSeekStage
        @ObservedObject var exercicesSharedData: ExerciseSharedData
        let textSubInstructions: String
        let textButtonRobotFound: String
        let robotManager = RobotManager()

        var body: some View {
            ZStack {
                HiddenView(textSubInstructions: self.textSubInstructions)
                    .padding(.horizontal, 30)

                HStack {
                    Spacer()
                    VStack(spacing: 70) {
                        self.stimulationButton(Stimulation.light) {
                            self.robotManager.runRandomReinforcer()
                        }
                        self.stimulationButton(Stimulation.motion) {
                            self.robotManager.wiggle(for: 1)
                        }
                    }
                    .padding(.trailing, 60)
                }

                VStack {
                    Spacer()

                    Button {
                        self.exercicesSharedData.state = .completed
                    } label: {
                        ButtonLabel(self.textButtonRobotFound, color: .cyan)
                    }
                    .padding(.vertical, 30)
                }
            }
            .padding(.vertical, 40)
        }

        func stimulationButton(_ stimulation: Stimulation, action: @escaping (() -> Void)) -> some View {
            stimulation.icon()
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 108, maxHeight: 108)
                .padding(20)
                .background(
                    Circle()
                        .fill(.white)
                )
                .onTapGesture {
                    action()
                }
        }
    }
}

// swiftlint:enable nesting

#Preview {
    HideAndSeekView.Player(
        stage: .constant(.hidden), textSubInstructions: "Example", textButtonRobotFound: "Trouvé",
        shared: ExerciseSharedData()
    )
}
