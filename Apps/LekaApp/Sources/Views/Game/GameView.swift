// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Lottie
import SwiftUI

struct GameView: View {
    // MARK: Internal

    @StateObject var gameMetrics = GameMetrics()
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var robotVM: RobotViewModel
    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        DesignKitAsset.Colors.lekaLightBlue.swiftUIColor
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .tint(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
            .overlay(
                VStack(spacing: 0) {
                    VStack(spacing: gameMetrics.headerSpacing) {
                        ProgressBarView(gameMetrics: gameMetrics)
                        InstructionButton(gameMetrics: gameMetrics)
                    }
                    .frame(maxHeight: gameMetrics.headerTotalHeight)
                    .padding(.top, gameMetrics.headerPadding)

                    VStack {
                        Spacer()
                        PlayZone(gameMetrics: gameMetrics)
                            .layoutPriority(1)
                        Spacer()
                    }
                }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            activityVM.resetActivity()
                            navigationVM.showActivitiesFullScreenCover = false
                            robotVM.userChoseToPlayWithoutRobot = false
                            // show alert to inform about losing the progress??
                        },
                        label: {
                            Image(systemName: "chevron.left")
                                .padding(.horizontal)
                        }
                    )
                    .disabled(activityVM.tapIsDisabled)
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 4) {
                        Text(activityVM.currentActivityTitle)
                        if settings.companyIsConnected, settings.exploratoryModeIsOn {
                            Image(systemName: "binoculars.fill")
                        }
                    }
                    .font(gameMetrics.semi17)
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    infoButton
                }
            }
            .sheet(isPresented: $showInstructionModal) {
                CurrentGameInstructionView(gameMetrics: gameMetrics)
            }
            .overlay(
                ZStack {
                    if activityVM.showMotivator {
                        successScreen
                    } else if activityVM.showEndAnimation {
                        cheerScreen
                    } else {
                        // Not an EmptyView() to avoid breaking the opacity animation
                        Rectangle()
                            .fill(Color.clear)
                    }
                }
                .background(content: {
                    Group {
                        if activityVM.showBlurryBG {
                            Rectangle()
                                .fill(.regularMaterial)
                                .transition(.opacity)
                        }
                    }
                    .animation(.default, value: activityVM.showBlurryBG)
                })
                .edgesIgnoringSafeArea(.all)
            )
            .background(
                GeometryReader { reader in
                    Color.clear
                        .onAppear {
                            offsetGameOverBtn = -reader.frame(in: .local).width / 2
                            offsetReplayBtn = reader.frame(in: .local).width / 2
                            initialBtnOffsets = [offsetGameOverBtn, offsetReplayBtn]
                        }
                })
    }

    @ViewBuilder
    func resultMessage(result: ResultType) -> some View {
        // Localized Strings
        let topMessage = switch result {
            case .fail:
                Text("fail_top_message")
            case .medium:
                Text("medium_top_message")
            case .success:
                Text("success_top_message")
            default:
                Text("")
        }

        let bottomMessage = switch result {
            case .fail:
                Text("fail_bottom_message")
                    + Text("(0%)")
                    .foregroundColor(DesignKitAsset.Colors.bravoHighlights.swiftUIColor)
                    + Text(".")
            case .medium,
                 .success:
                Text("success_bottom_message")
                    + Text(
                        "success_bottom_result \(activityVM.goodAnswers) \(activityVM.numberOfSteps) \(activityVM.percentOfSuccess)"
                    )
                    .foregroundColor(DesignKitAsset.Colors.bravoHighlights.swiftUIColor)
                    + Text("!")
            default:
                Text("")
        }

        VStack(spacing: gameMetrics.endAnimTextsSpacing) {
            Group {
                topMessage
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                    .offset(y: textOffset)
                    .opacity(textOpacity)
                    .animation(
                        .easeOut(duration: gameMetrics.endAnimDuration).delay(gameMetrics.endAnimDelayTop),
                        value: textOffset
                    )
                    .animation(
                        .easeOut(duration: gameMetrics.endAnimDuration).delay(gameMetrics.endAnimDelayTop),
                        value: textOpacity
                    )
                bottomMessage
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
                    .offset(y: textOffset)
                    .opacity(textOpacity)
                    .animation(
                        .easeOut(duration: gameMetrics.endAnimDuration).delay(gameMetrics.endAnimDelayBottom),
                        value: textOffset
                    )
                    .animation(
                        .easeOut(duration: gameMetrics.endAnimDuration).delay(gameMetrics.endAnimDelayBottom),
                        value: textOpacity
                    )
            }
            .font(
                .system(
                    size: gameMetrics.endAnimFontSize,
                    weight: gameMetrics.endAnimFontWeight,
                    design: gameMetrics.endAnimFontDesign
                ))
        }
    }

    // MARK: Private

    @State private var textOffset: CGFloat = -100
    @State private var textOpacity: Double = 0
    @State private var offsetGameOverBtn: CGFloat = 0
    @State private var offsetReplayBtn: CGFloat = 0
    @State private var initialBtnOffsets: [CGFloat] = []

    @State private var showInstructionModal: Bool = false

    private var infoButton: some View {
        Button {
            showInstructionModal.toggle()
        } label: {
            Image(systemName: "info.circle")
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        }
        .opacity(showInstructionModal ? 0 : 1)
    }

    private var successScreen: some View {
        LottieView(
            name: "motivator", speed: 0.5,
            action: { activityVM.hideMotivator() },
            play: $activityVM.showMotivator
        )
        .scaleEffect(gameMetrics.motivatorScale, anchor: .center)
    }

    private var cheerScreen: some View {
        ZStack {
            LottieView(
                name: activityVM.percentOfSuccess >= 80 ? "bravo" : "tryAgain", play: $activityVM.showEndAnimation
            )
            .onAppear {
                // Delayed to avoid artifacts on animation... SwiftUI bug
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    textOffset = 0
                    textOpacity = 1
                    offsetGameOverBtn = 0
                    offsetReplayBtn = 0
                }
            }

            VStack(spacing: 0) {
                resultMessage(result: activityVM.result)
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        navigationVM.showActivitiesFullScreenCover = false
                        robotVM.userChoseToPlayWithoutRobot = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            activityVM.resetActivity()
                        }
                    } label: {
                        Text("gameOver_button")
                    }
                    .buttonStyle(BorderedCapsule_ButtonStyle(isFilled: false))
                    .offset(x: offsetGameOverBtn)
                    .animation(
                        .easeOut(duration: gameMetrics.endAnimBtnDuration).delay(gameMetrics.endAnimGameOverBtnDelay),
                        value: offsetGameOverBtn
                    )
                    Spacer()
                    Button {
                        activityVM.replayCurrentActivity()
                        textOffset = -100
                        textOpacity = 0
                        offsetGameOverBtn = initialBtnOffsets[0]
                        offsetReplayBtn = initialBtnOffsets[1]
                    } label: {
                        Text("replay_button")
                    }
                    .buttonStyle(BorderedCapsule_ButtonStyle())
                    .offset(x: offsetReplayBtn)
                    .animation(
                        .easeOut(duration: gameMetrics.endAnimBtnDuration).delay(gameMetrics.endAnimReplayBtnDelay),
                        value: offsetReplayBtn
                    )
                    Spacer()
                }
            }
            .padding(.vertical, gameMetrics.endAnimBtnPadding)
        }
    }
}
