// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

struct NewHideAndSeekView: View {
    // MARK: Lifecycle

    init(viewModel: NewHideAndSeekViewViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    enum HideAndSeekStage {
        case toHide
        case hidden
    }

    var body: some View {
        switch self.stage {
            case .toHide:
                VStack {
                    Text(l10n.HideAndSeekView.Launcher.instructions)
                        .font(.headline)
                    ContentKitAsset.Exercises.HideAndSeek.imageIllustration.swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 500, height: 500)

                    Button {
                        self.stage = .hidden
                    } label: {
                        CapsuleColoredButtonLabel(String(l10n.HideAndSeekView.Launcher.okButtonLabel.characters).uppercased(), color: .cyan)
                    }
                }
                .scaledToFill()
            case .hidden:
                ZStack {
                    HideAndSeekLottieView()
                        .padding(.horizontal, 30)

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
                            CapsuleColoredButtonLabel(String(l10n.HideAndSeekView.Player.foundButtonLabel.characters).uppercased(), color: .cyan)
                        }
                        .padding(.vertical, 30)
                    }
                }
                .padding(.vertical, 40)
        }
    }

    // MARK: Private

    @State private var stage: HideAndSeekStage = .toHide

    private let viewModel: NewHideAndSeekViewViewModel
}

#Preview {
    let coordinator = NewHideAndSeekCoordinator()
    let viewModel = NewHideAndSeekViewViewModel(coordinator: coordinator)

    return NewHideAndSeekView(viewModel: viewModel)
}
