// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import Lottie
import RobotKit
import SwiftUI

// swiftlint:disable cyclomatic_complexity void_function_in_ternary function_body_length

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
                .blur(radius: self.blurRadius)
                .opacity(self.opacity)
                .onChange(of: self.viewModel.isReinforcerAnimationVisible) {
                    if $0 {
                        withAnimation(.easeInOut.delay(0.5)) {
                            self.blurRadius = 20
                        }
                    } else {
                        withAnimation {
                            self.blurRadius = 0
                        }
                    }
                }
                .onChange(of: self.viewModel.isCurrentActivityCompleted) {
                    if $0 {
                        withAnimation {
                            self.opacity = 0
                        }
                    } else {
                        withAnimation {
                            self.opacity = 1
                        }
                    }
                }

                if self.viewModel.isReinforcerAnimationVisible {
                    self.reinforcerAnimationView
                        .frame(maxWidth: .infinity)
                }

                HStack {
                    if case .completed = self.viewModel.currentExerciseSharedData.state {
                        if self.viewModel.isReinforcerAnimationVisible {
                            self.hideReinforcerToShowAnswersButton
                        }
                        self.continueButton
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(.lkBackground)
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationTitle(self.viewModel.currentActivity.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.viewModel.moveToPreviousExercise()
                    } label: {
                        Image(systemName: "arrow.backward")
                    }
                    .disabled(self.viewModel.isFirstExercise)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.isInfoSheetPresented.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.viewModel.isReinforcerAnimationEnabled.toggle()
                    } label: {
                        Image(systemName: self.viewModel.isReinforcerAnimationEnabled ? "circle" : "circle.slash")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(l10n.GameEngineKit.ActivityView.Toolbar.dismissButton.characters)) {
                        self.dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.viewModel.moveToNextExercise()
                    } label: {
                        Image(systemName: "arrow.forward")
                    }
                    .disabled(self.viewModel.isLastExercise)
                }
            }
            .sheet(isPresented: self.$isInfoSheetPresented) {
                // TODO: (@team) - Add YAML description of activities
                Text("Info related to the activity ")
            }
            .fullScreenCover(isPresented: self.$viewModel.isCurrentActivityCompleted) {
                self.endOfActivityScoreView
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

    @State private var opacity: Double = 1
    @State private var blurRadius: CGFloat = 0
    @State private var showScoreView: Bool = false
    @State private var isInfoSheetPresented: Bool = false

    private let robot = Robot.shared

    @ViewBuilder
    private var endOfActivityScoreView: some View {
        if self.viewModel.didCompleteActivitySuccessfully {
            SuccessView(percentage: self.viewModel.activityCompletionSuccessPercentage)
        } else {
            FailureView(percentage: self.viewModel.activityCompletionSuccessPercentage)
        }
    }

    @ViewBuilder
    private var reinforcerAnimationView: some View {
        LottieView(
            animation: .reinforcer,
            speed: 0.2
        )
        .onAppear {
            // TODO(@ladislas/@hugo): Use reinforcer children choice
            self.robot.run(.fire)
        }
        .transition(
            .asymmetric(
                insertion: .opacity.animation(.snappy.delay(0.75)),
                removal: .identity
            )
        )
    }

    @ViewBuilder
    private var continueButton: some View {
        Button(String(l10n.GameEngineKit.ActivityView.continueButton.characters)) {
            if self.viewModel.isLastExercise {
                self.viewModel.scorePanelEnabled ? self.viewModel.moveToActivityEnd() : self.dismiss()
            } else {
                self.viewModel.moveToNextExercise()
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .padding()
        .transition(
            .asymmetric(
                insertion: .opacity.animation(.snappy.delay(self.viewModel.delayAfterReinforcerAnimation)),
                removal: .identity
            )
        )
    }

    @ViewBuilder
    private var hideReinforcerToShowAnswersButton: some View {
        Button(String(l10n.GameEngineKit.ActivityView.hideReinforcerToShowAnswersButton.characters)) {
            withAnimation {
                self.viewModel.isReinforcerAnimationVisible = false
            }
        }
        .buttonStyle(.bordered)
        .padding()
        .transition(
            .asymmetric(
                insertion: .opacity.animation(.snappy.delay(self.viewModel.delayAfterReinforcerAnimation)),
                removal: .identity
            )
        )
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
                    data: self.viewModel.currentExerciseSharedData
                )
        }
    }
}

// swiftlint:enable cyclomatic_complexity void_function_in_ternary function_body_length

#Preview {
    let activity = ContentKit.decodeActivityDeprecated("activity-sample")
    return ActivityView(viewModel: ActivityViewViewModel(activity: activity))
}