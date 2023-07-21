// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Lottie
import SwiftUI

struct GameView: View {

    @StateObject var gameMetrics = GameMetrics()
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @Environment(\.dismiss) var dismiss

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
                .foregroundColor(.accentColor)
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

    @ViewBuilder
    func resultMessage(result: ResultType) -> some View {
        // Localized Strings
        let topMessage: Text = {
            switch result {
                case .fail:
                    return Text("fail_top_message")
                case .medium:
                    return Text("medium_top_message")
                case .success:
                    return Text("success_top_message")
                default:
                    return Text("")
            }
        }()

        let bottomMessage: Text = {
            switch result {
                case .fail:
                    return Text("fail_bottom_message")
                        + Text("(0%)")
                        .foregroundColor(Color("bravoHighlights"))
                        + Text(".")
                case .medium, .success:
                    return Text("success_bottom_message")
                        + Text(
                            "success_bottom_result \(activityVM.goodAnswers) \(activityVM.numberOfSteps) \(activityVM.percentOfSuccess)"
                        )
                        .foregroundColor(Color("bravoHighlights"))
                        + Text("!")
                default:
                    return Text("")
            }
        }()

        VStack(spacing: gameMetrics.endAnimTextsSpacing) {
            Group {
                topMessage
                    .foregroundColor(.accentColor)
                    .offset(y: textOffset)
                    .opacity(textOpacity)
                    .animation(
                        .easeOut(duration: gameMetrics.endAnimDuration).delay(gameMetrics.endAnimDelayTop),
                        value: textOffset
                    )
                    .animation(
                        .easeOut(duration: gameMetrics.endAnimDuration).delay(gameMetrics.endAnimDelayTop),
                        value: textOpacity)
                bottomMessage
                    .foregroundColor(Color("lekaDarkGray"))
                    .offset(y: textOffset)
                    .opacity(textOpacity)
                    .animation(
                        .easeOut(duration: gameMetrics.endAnimDuration).delay(gameMetrics.endAnimDelayBottom),
                        value: textOffset
                    )
                    .animation(
                        .easeOut(duration: gameMetrics.endAnimDuration).delay(gameMetrics.endAnimDelayBottom),
                        value: textOpacity)
            }
            .font(
                .system(
                    size: gameMetrics.endAnimFontSize,
                    weight: gameMetrics.endAnimFontWeight,
                    design: gameMetrics.endAnimFontDesign))
        }
    }

    private var cheerScreen: some View {
        ZStack {
            LottieView(
                name: activityVM.percentOfSuccess >= 80 ? "activity_end-success" : "activity_end-try_again", play: $activityVM.showEndAnimation
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
                        withAnimation {
                            viewRouter.currentPage = .home
                        }
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
                        value: offsetGameOverBtn)
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
                        value: offsetReplayBtn)
                    Spacer()
                }
            }
            .padding(.vertical, gameMetrics.endAnimBtnPadding)
        }
    }

    var body: some View {
        Color("lekaLightBlue")
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .tint(.accentColor)
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
                            if viewRouter.currentPage == .curriculumDetail {
                                dismiss()
                                viewRouter.goToGameFromCurriculums = false
                            } else {
                                withAnimation {
                                    viewRouter.currentPage = .home
                                }
                                viewRouter.goToGameFromActivities = false
                            }
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
                        if settings.companyIsConnected && settings.exploratoryModeIsOn {
                            Image(systemName: "binoculars.fill")
                        }
                    }
                    .font(gameMetrics.semi17)
                    .foregroundColor(.accentColor)
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
}
