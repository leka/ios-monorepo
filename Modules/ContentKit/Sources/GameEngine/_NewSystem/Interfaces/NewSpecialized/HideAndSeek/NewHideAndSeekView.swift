// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - NewHideAndSeekView

struct NewHideAndSeekView: View {
    // MARK: Lifecycle

    init(viewModel: NewHideAndSeekViewViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        ZStack {
            ZStack {
                HideAndSeekLottieView()

                HStack {
                    Spacer()
                    VStack(spacing: 70) {
                        HideAndSeekStimulationButton(stimulation: Stimulation.light) {
                            self.viewModel.triggerLight()
                        }
                        HideAndSeekStimulationButton(stimulation: Stimulation.motion) {
                            self.viewModel.triggerMotion()
                        }
                    }
                    .padding(.trailing, 60)
                }

                VStack {
                    Spacer()

                    Button {
                        self.viewModel.completeHideAndSeek()
                    } label: {
                        CapsuleColoredButtonLabel(String(l10n.NewHideAndSeekView.foundButtonLabel.characters).uppercased(), color: .cyan)
                    }
                    .padding(.bottom)
                }
            }
            .blur(radius: self.blurRadius)

            if !self.isRobotHidden {
                Button {
                    self.isRobotHidden = true
                } label: {
                    CapsuleColoredButtonLabel(String(l10n.NewHideAndSeekView.instructionsButtonLabel.characters), color: .cyan)
                }
            }
        }
        .onChange(of: self.isRobotHidden) {
            if !self.isRobotHidden {
                withAnimation(.easeInOut.delay(0.5)) {
                    self.blurRadius = 20
                }
            } else {
                self.blurRadius = 0
            }
        }
    }

    // MARK: Private

    @State private var isRobotHidden: Bool = false
    @State private var blurRadius: CGFloat = 20

    private let viewModel: NewHideAndSeekViewViewModel
}

// MARK: - l10n.NewHideAndSeekView

extension l10n {
    enum NewHideAndSeekView {
        static let instructionsButtonLabel = LocalizedString("game_engine_kit.hide_and_seek_view.instructions_button_label",
                                                             bundle: ContentKitResources.bundle,
                                                             value: "Press when Leka is hidden",
                                                             comment: "HideAndSeekView Launcher instructions button label")

        static let instructionsLabel = LocalizedString("game_engine_kit.hide_and_seek_view.instructions",
                                                       bundle: ContentKitResources.bundle,
                                                       value: """
                                                           Encourage the care receiver to seek Leka.

                                                           You can throw a reinforcer to give him a visual and/or audible clue.

                                                           Press FOUND! once the robot found.
                                                           """,
                                                       comment: "HideAndSeekView instructions when Leka is hidden")

        static let foundButtonLabel = LocalizedString("game_engine_kit.hide_and_seek_view.found_button_label",
                                                      bundle: ContentKitResources.bundle,
                                                      value: "Found!",
                                                      comment: "HideAndSeekView Player Found Button label")
    }
}

#Preview {
    let coordinator = NewHideAndSeekCoordinator()
    let viewModel = NewHideAndSeekViewViewModel(coordinator: coordinator)

    return NewHideAndSeekView(viewModel: viewModel)
}
