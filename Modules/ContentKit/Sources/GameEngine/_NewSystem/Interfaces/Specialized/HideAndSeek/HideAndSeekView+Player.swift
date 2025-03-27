// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import RobotKit
import SwiftUI

// swiftlint:disable nesting
extension HideAndSeekView {
    struct Player: View {
        // MARK: Lifecycle

        init(stage: Binding<HideAndSeekStage>, shared: ExerciseSharedData? = nil) {
            _stage = stage

            self.exercicesSharedData = shared ?? ExerciseSharedData()
            self.exercicesSharedData.state = .playing()
        }

        // MARK: Internal

        enum Stimulation: String, CaseIterable {
            case light
            case motion

            // MARK: Public

            public func icon() -> Image {
                switch self {
                    case .light:
                        ContentKitAsset.Exercises.HideAndSeek.iconStimulationLight.swiftUIImage
                    case .motion:
                        ContentKitAsset.Exercises.HideAndSeek.iconStimulationMotion.swiftUIImage
                }
            }
        }

        @Binding var stage: HideAndSeekStage
        @ObservedObject var exercicesSharedData: ExerciseSharedData

        let robotManager = RobotManager()

        var body: some View {
            ZStack {
                HiddenView()
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
                        self.exercicesSharedData.state = .completed(level: .nonApplicable)
                    } label: {
                        ButtonLabel(String(l10n.HideAndSeekView.Player.foundButtonLabel.characters).uppercased(), color: .cyan)
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
    HideAndSeekView.Player(stage: .constant(.hidden), shared: ExerciseSharedData())
}
