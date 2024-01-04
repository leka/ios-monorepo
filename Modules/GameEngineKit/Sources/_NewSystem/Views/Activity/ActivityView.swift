// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import Lottie
import RobotKit
import SwiftUI

// swiftlint:disable cyclomatic_complexity void_function_in_ternary function_body_length

extension LottieAnimation {
    static var reinforcer: LottieAnimation {
        LottieAnimation.named("reinforcer-spin-blink", bundle: .module)!
    }

    static var bravo: LottieAnimation {
        LottieAnimation.named("bravo", bundle: .module)!
    }

    static var tryAgain: LottieAnimation {
        LottieAnimation.named("tryAgain", bundle: .module)!
    }
}

// MARK: - ActivityView

public struct ActivityView: View {
    // MARK: Lifecycle

    public init(viewModel: ActivityViewViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Public

    public var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    VStack(spacing: 15) {
                        if self.viewModel.isProgressBarVisible {
                            ActivityProgressBar(viewModel: self.viewModel)
                        }

                        if self.viewModel.isExerciseInstructionsButtonVisible {
                            ExerciseInstructionsButton(instructions: self.viewModel.currentExercise.instructions)
                        }
                    }

                    VStack {
                        Spacer()
                        self.currentExerciseInterface()
                        Spacer()
                    }
                }
                .id(self.viewModel.currentExerciseIndexInSequence)
                .blur(radius: self.viewModel.isReinforcerLottieAnimationDisplayed && self.viewModel.isReinforcerLottieAnimationEnabled ? 20 : 0)
                .opacity(self.viewModel.isCurrentActivityCompleted ? 0 : 1)

                self.lottieReinforcer

                self.lottieScoreView

                HStack {
                    self.dismissReinforcerButton

                    self.continueButton
                }
            }
            .frame(maxWidth: .infinity)
            .background(.lkBackground)
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(self.viewModel.currentActivity.name)
                        .font(.headline)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.viewModel.moveToPreviousExercise()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    .disabled(self.viewModel.isFirstExercise)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.viewModel.isReinforcerLottieAnimationEnabled.toggle()
                        self.viewModel.isReinforcerLottieAnimationDisplayed = false
                    } label: {
                        Image(systemName: self.viewModel.isReinforcerLottieAnimationEnabled ? "circle" : "circle.slash")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Dismiss") {
                        self.dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.viewModel.moveToNextExercise()
                    } label: {
                        Image(systemName: "chevron.forward")
                    }
                    .disabled(self.viewModel.isLastExercise)
                }
            }
        }
        .onAppear {
            Robot.shared.stop()
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            Robot.shared.stop()
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: ActivityViewViewModel

    // MARK: Private

    private let robot = Robot.shared

    @ViewBuilder
    private var lottieScoreView: some View {
        let isScoreDisplayed = self.viewModel.isCurrentActivityCompleted

        if isScoreDisplayed, self.viewModel.isCurrentActivitySucceeded {
            SuccessView()
        } else if isScoreDisplayed, !self.viewModel.isCurrentActivitySucceeded {
            FailureView()
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private var lottieReinforcer: some View {
        let isReinforcerDisplayed = self.viewModel.isReinforcerLottieAnimationDisplayed
        let isReinforcerEnabled = self.viewModel.isReinforcerLottieAnimationEnabled

        if isReinforcerDisplayed, isReinforcerEnabled {
            LottieView(
                animation: .reinforcer,
                speed: 0.2
            )
            .onAppear {
                // TODO(@ladislas/@hugo): Use reinforcer children choice
                self.robot.run(.fire)
            }
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private var continueButton: some View {
        let state = self.viewModel.currentExerciseSharedData.state

        if state != .completed {
            EmptyView()
        } else {
            Button("Continuer") {
                if self.viewModel.isCurrentActivityCompleted {
                    self.dismiss()
                } else {
                    self.viewModel.isLastExercise ? self.viewModel.moveToScorePanel() : self.viewModel.moveToNextExercise()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .padding()
            .transition(.asymmetric(insertion: .opacity.animation(.snappy.delay(self.viewModel.isReinforcerLottieAnimationEnabled ? 5 : 0.5)), removal: .identity))
        }
    }

    @ViewBuilder
    private var dismissReinforcerButton: some View {
        let isLottieDisplayed = self.viewModel.isReinforcerLottieAnimationDisplayed

        if isLottieDisplayed {
            Button("Revoir les réponses") {
                withAnimation {
                    self.viewModel.isReinforcerLottieAnimationDisplayed = false
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .padding()
            .transition(.asymmetric(insertion: .opacity.animation(.snappy.delay(self.viewModel.isReinforcerLottieAnimationDisplayed ? 5 : 0.5)), removal: .identity))
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func currentExerciseInterface() -> some View {
        switch self.viewModel.currentExerciseInterface {
            case .touchToSelect:
                TouchToSelectView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .robotThenTouchToSelect:
                RobotThenTouchToSelectView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .listenThenTouchToSelect:
                ListenThenTouchToSelectView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .observeThenTouchToSelect:
                ObserveThenTouchToSelectView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .dragAndDropIntoZones:
                DragAndDropIntoZonesView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .dragAndDropToAssociate:
                DragAndDropToAssociateView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .danceFreeze:
                DanceFreezeView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .remoteStandard:
                RemoteStandard.MainView()

            case .remoteArrow:
                RemoteArrowView()

            case .hideAndSeek:
                HideAndSeekView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .musicalInstruments:
                MusicalInstrumentView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .melody:
                MelodyView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .pairing:
                PairingView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )
        }
    }
}

// swiftlint:enable cyclomatic_complexity void_function_in_ternary function_body_length

#Preview {
    let activity = ContentKit.decodeActivity("activity-sample")
    return ActivityView(viewModel: ActivityViewViewModel(activity: activity))
}
