// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable cyclomatic_complexity void_function_in_ternary function_body_length

import AccountKit
import Combine
import ContentKit
import DesignKit
import LocalizationKit
import Lottie
import RobotKit
import SwiftUI

// MARK: - ActivityView

public struct ActivityView: View {
    // MARK: Lifecycle

    public init(activity: Activity, reinforcer: Robot.Reinforcer = .rainbow) {
        self._viewModel = StateObject(wrappedValue: ActivityViewViewModel(activity: activity))
        self.reinforcer = reinforcer
    }

    // MARK: Public

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                VStack(spacing: 15) {
                    if self.viewModel.isProgressBarVisible {
                        ActivityProgressBar(viewModel: self.viewModel)
                    }

                    if self.viewModel.isExerciseInstructionsButtonVisible {
                        ExerciseInstructionsButton(instructions: self.viewModel.currentExercise.instructions!)
                    }
                }

                VStack {
                    Spacer()
                    self.currentExerciseInterface()
                    Spacer()
                }
            }
            .id(self.viewModel.currentExerciseIndexInCurrentGroup)
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

            if case .validating = self.viewModel.currentExerciseSharedData.state {
                CountdownView(duration: 10) {
                    self.viewModel.currentExerciseSharedData.state = .completed(level: .excellent)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.lkBackground)
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationTitle(self.viewModel.currentActivity.details.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.isAlertPresented = true
                } label: {
                    Image(systemName: "xmark.circle")
                }
            }

            #if DEVELOPER_MODE
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.viewModel.isReinforcerAnimationEnabled.toggle()
                    } label: {
                        Image(systemName: self.viewModel.isReinforcerAnimationEnabled ? "livephoto" : "livephoto.slash")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.viewModel.moveToPreviousExercise()
                    } label: {
                        Image(systemName: "arrow.backward")
                    }
                    .disabled(self.viewModel.isFirstExercise)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.viewModel.moveToNextExercise()
                    } label: {
                        Image(systemName: "arrow.forward")
                    }
                    .disabled(self.viewModel.isLastExercise)
                }
            #endif

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.isInfoSheetPresented.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .alert(String(l10n.GameEngineKit.ActivityView.QuitActivityAlert.title.characters), isPresented: self.$isAlertPresented) {
            Button(String(l10n.GameEngineKit.ActivityView.QuitActivityAlert.cancelButtonLabel.characters), role: .cancel, action: {
                self.isAlertPresented = false
            })
            Button(String(l10n.GameEngineKit.ActivityView.QuitActivityAlert.quitButtonLabel.characters), role: .destructive, action: {
                self.saveActivityCompletion()
                self.dismiss()
            })
        } message: {
            Text(l10n.GameEngineKit.ActivityView.QuitActivityAlert.message)
        }
        .sheet(isPresented: self.$isInfoSheetPresented) {
            ActivityDetailsView(activity: self.viewModel.currentActivity)
        }
        .fullScreenCover(isPresented: self.$viewModel.isCurrentActivityCompleted) {
            self.endOfActivityScoreView
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

    // TODO: (@ladislas) was @ObservedObject, check why
    @StateObject var viewModel: ActivityViewViewModel

    // MARK: Private

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()
    @StateObject private var carereceiverManagerViewModel = CarereceiverManagerViewModel()

    @State private var isAlertPresented: Bool = false

    @State private var opacity: Double = 1
    @State private var blurRadius: CGFloat = 0
    @State private var showScoreView: Bool = false
    @State private var isInfoSheetPresented: Bool = false

    private let robot = Robot.shared
    private let reinforcer: Robot.Reinforcer

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
            self.robot.run(self.reinforcer)
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
                self.saveActivityCompletion()
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

            case .superSimon:
                SuperSimonView(
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

            case .dragAndDropAnyAnswer:
                DragAndDropAnyAnswerView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .listenThenDragAndDropIntoZones:
                ListenThenDragAndDropIntoZonesView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .observeThenDragAndDropIntoZones:
                ObserveThenDragAndDropIntoZonesView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .robotThenDragAndDropIntoZones:
                RobotThenDragAndDropIntoZonesView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .dragAndDropToAssociate:
                DragAndDropToAssociateView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .listenThenDragAndDropToAssociate:
                ListenThenDragAndDropToAssociateView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .observeThenDragAndDropToAssociate:
                ObserveThenDragAndDropToAssociateView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .robotThenDragAndDropToAssociate:
                RobotThenDragAndDropToAssociateView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .dragAndDropInOrder:
                DragAndDropInOrderView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .danceFreeze:
                DanceFreezeView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )

            case .gamepadJoyStickColorPad:
                Gamepad.Joystick()

            case .gamepadArrowPadColorPad:
                Gamepad.ArrowPadColorPad()

            case .gamepadArrowPad:
                ArrowPadView(size: 200, xPosition: 180)

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
                DiscoverLekaView(
                    data: self.viewModel.currentExerciseSharedData
                )

            case .memory:
                MemoryView(
                    exercise: self.viewModel.currentExercise,
                    data: self.viewModel.currentExerciseSharedData
                )
        }
    }

    private func saveActivityCompletion() {
        let caregiverID = self.caregiverManagerViewModel.currentCaregiver?.id
        let carereceiverIDs = self.carereceiverManagerViewModel.currentCarereceivers.compactMap(\.id)
        self.viewModel.saveActivityCompletion(caregiverID: caregiverID, carereceiverIDs: carereceiverIDs)
    }
}

// swiftlint:enable cyclomatic_complexity void_function_in_ternary function_body_length

#Preview {
    NavigationStack {
        ActivityView(activity: Activity.mock)
    }
}
