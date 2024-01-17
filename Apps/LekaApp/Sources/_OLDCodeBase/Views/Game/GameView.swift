// Leka - iOS Monorepo
// Copyright APF France handicap
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
    @EnvironmentObject var settings: SettingsViewModelDeprecated
    @Environment(\.dismiss) var dismiss

    var body: some View {
        DesignKitAsset.Colors.lekaLightBlue.swiftUIColor
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .overlay(
                VStack(spacing: 0) {
                    VStack(spacing: self.gameMetrics.headerSpacing) {
                        ProgressBarView(gameMetrics: self.gameMetrics)
                        InstructionButton(gameMetrics: self.gameMetrics)
                    }
                    .frame(maxHeight: self.gameMetrics.headerTotalHeight)
                    .padding(.top, self.gameMetrics.headerPadding)

                    VStack {
                        Spacer()
                        PlayZone(gameMetrics: self.gameMetrics)
                            .layoutPriority(1)
                        Spacer()
                    }
                }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            self.activityVM.resetActivity()
                            self.navigationVM.showActivitiesFullScreenCover = false
                            self.robotVM.userChoseToPlayWithoutRobot = false
                            // show alert to inform about losing the progress??
                        },
                        label: {
                            Image(systemName: "chevron.left")
                                .padding(.horizontal)
                        }
                    )
                    .disabled(self.activityVM.tapIsDisabled)
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 4) {
                        Text(self.activityVM.currentActivityTitle)
                        if self.settings.companyIsConnected, self.settings.exploratoryModeIsOn {
                            Image(systemName: "binoculars.fill")
                        }
                    }
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.subheadline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    self.infoButton
                }
            }
            .sheet(isPresented: self.$showInstructionModal) {
                CurrentGameInstructionView(gameMetrics: self.gameMetrics)
            }
            .overlay(
                ZStack {
                    if self.activityVM.showMotivator {
                        self.successScreen
                    } else if self.activityVM.showEndAnimation {
                        self.cheerScreen
                    } else {
                        // Not an EmptyView() to avoid breaking the opacity animation
                        Rectangle()
                            .fill(Color.clear)
                    }
                }
                .background(content: {
                    Group {
                        if self.activityVM.showBlurryBG {
                            Rectangle()
                                .fill(.regularMaterial)
                                .transition(.opacity)
                        }
                    }
                    .animation(.default, value: self.activityVM.showBlurryBG)
                })
                .edgesIgnoringSafeArea(.all)
            )
            .background(
                GeometryReader { reader in
                    Color.clear
                        .onAppear {
                            self.offsetGameOverBtn = -reader.frame(in: .local).width / 2
                            self.offsetReplayBtn = reader.frame(in: .local).width / 2
                            self.initialBtnOffsets = [self.offsetGameOverBtn, self.offsetReplayBtn]
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
                        "success_bottom_result \(self.activityVM.goodAnswers) \(self.activityVM.numberOfSteps) \(self.activityVM.percentOfSuccess)"
                    )
                    .foregroundColor(DesignKitAsset.Colors.bravoHighlights.swiftUIColor)
                    + Text("!")
            default:
                Text("")
        }

        VStack(spacing: self.gameMetrics.endAnimTextsSpacing) {
            Group {
                topMessage
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                    .offset(y: self.textOffset)
                    .opacity(self.textOpacity)
                    .animation(
                        .easeOut(duration: self.gameMetrics.endAnimDuration).delay(self.gameMetrics.endAnimDelayTop),
                        value: self.textOffset
                    )
                    .animation(
                        .easeOut(duration: self.gameMetrics.endAnimDuration).delay(self.gameMetrics.endAnimDelayTop),
                        value: self.textOpacity
                    )
                bottomMessage
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
                    .offset(y: self.textOffset)
                    .opacity(self.textOpacity)
                    .animation(
                        .easeOut(duration: self.gameMetrics.endAnimDuration).delay(self.gameMetrics.endAnimDelayBottom),
                        value: self.textOffset
                    )
                    .animation(
                        .easeOut(duration: self.gameMetrics.endAnimDuration).delay(self.gameMetrics.endAnimDelayBottom),
                        value: self.textOpacity
                    )
            }
            // TODO: (@ui/ux) - Design System - replace with Leka font
            .font(.largeTitle)
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
            self.showInstructionModal.toggle()
        } label: {
            Image(systemName: "info.circle")
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        }
        .opacity(self.showInstructionModal ? 0 : 1)
    }

    private var successScreen: some View {
        LottieView(
            name: "motivator", speed: 0.5,
            action: { self.activityVM.hideMotivator() },
            play: self.$activityVM.showMotivator
        )
        .scaleEffect(self.gameMetrics.motivatorScale, anchor: .center)
    }

    private var cheerScreen: some View {
        ZStack {
            LottieView(
                name: self.activityVM.percentOfSuccess >= 80 ? "bravo" : "tryAgain", play: self.$activityVM.showEndAnimation
            )
            .onAppear {
                // Delayed to avoid artifacts on animation... SwiftUI bug
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.textOffset = 0
                    self.textOpacity = 1
                    self.offsetGameOverBtn = 0
                    self.offsetReplayBtn = 0
                }
            }

            VStack(spacing: 0) {
                self.resultMessage(result: self.activityVM.result)
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        self.navigationVM.showActivitiesFullScreenCover = false
                        self.robotVM.userChoseToPlayWithoutRobot = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.activityVM.resetActivity()
                        }
                    } label: {
                        Text("gameOver_button")
                    }
                    .buttonStyle(BorderedCapsule_ButtonStyle(isFilled: false))
                    .offset(x: self.offsetGameOverBtn)
                    .animation(
                        .easeOut(duration: self.gameMetrics.endAnimBtnDuration).delay(self.gameMetrics.endAnimGameOverBtnDelay),
                        value: self.offsetGameOverBtn
                    )
                    Spacer()
                    Button {
                        self.activityVM.replayCurrentActivity()
                        self.textOffset = -100
                        self.textOpacity = 0
                        self.offsetGameOverBtn = self.initialBtnOffsets[0]
                        self.offsetReplayBtn = self.initialBtnOffsets[1]
                    } label: {
                        Text("replay_button")
                    }
                    .buttonStyle(BorderedCapsule_ButtonStyle())
                    .offset(x: self.offsetReplayBtn)
                    .animation(
                        .easeOut(duration: self.gameMetrics.endAnimBtnDuration).delay(self.gameMetrics.endAnimReplayBtnDelay),
                        value: self.offsetReplayBtn
                    )
                    Spacer()
                }
            }
            .padding(.vertical, self.gameMetrics.endAnimBtnPadding)
        }
    }
}
