// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import DesignKit
import LocalizationKit
import Lottie
import RobotKit
import SwiftUI

// MARK: - ActivityViewViewModel

class ActivityViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(activity: Activity) {
        self.currentActivity = activity

        self.exerciseManager = ActivityExerciseManager(activity: activity)

        self.totalGroups = self.exerciseManager.totalGroups
        self.currentGroupIndex = self.exerciseManager.currentGroupIndex

        self.groupSizeEnumeration = activity.exerciseGroups.map(\.exercices.count)

        self.totalExercisesInCurrentGroup = self.exerciseManager.totalExercisesInCurrentGroup
        self.currentExerciseIndexInCurrentGroup = self.exerciseManager.currentExerciseIndexInCurrentGroup

        self.currentExercise = self.exerciseManager.currentExercise
        self.currentExerciseInterface = self.exerciseManager.currentExercise.interface

        self.currentExerciseSharedData = ExerciseSharedData(
            groupIndex: self.exerciseManager.currentGroupIndex,
            exerciseIndex: self.exerciseManager.currentExerciseIndexInCurrentGroup
        )
        self.completedExercisesSharedData.append(self.currentExerciseSharedData)

        self.subscribeToCurrentExerciseSharedDataUpdates()
    }

    // MARK: Internal

    @Published var currentActivity: Activity

    @Published var totalGroups: Int
    @Published var currentGroupIndex: Int
    @Published var groupSizeEnumeration: [Int]

    @Published var totalExercisesInCurrentGroup: Int
    @Published var currentExerciseIndexInCurrentGroup: Int

    @Published var currentExercise: Exercise
    @Published var currentExerciseInterface: Exercise.Interface

    @Published var completedExercisesSharedData: [ExerciseSharedData] = []
    @Published var currentExerciseSharedData: ExerciseSharedData

    @Published var isCurrentActivityCompleted: Bool = false
    @Published var isReinforcerAnimationVisible: Bool = false
    @Published var isReinforcerAnimationEnabled: Bool = true

    var successExercisesSharedData: [ExerciseSharedData] {
        self.completedExercisesSharedData.filter {
            $0.completionLevel == .excellent
                || $0.completionLevel == .good
        }
    }

    var didCompleteActivitySuccessfully: Bool {
        let minimalSuccessPercentage = 0.8

        return Double(self.successExercisesSharedData.count) > (Double(self.completedExercisesSharedData.count) * minimalSuccessPercentage)
    }

    var scorePanelEnabled: Bool {
        !self.completedExercisesSharedData.filter {
            $0.completionLevel != .nonApplicable
        }.isEmpty
    }

    var activityCompletionSuccessPercentage: Int {
        let successfulExercises = self.successExercisesSharedData.count
        let totalExercises = self.completedExercisesSharedData.filter {
            $0.completionLevel != .nonApplicable
        }.count

        return (successfulExercises / totalExercises) * 100
    }

    var delayAfterReinforcerAnimation: Double {
        self.isReinforcerAnimationEnabled ? 5 : 0.5
    }

    var isProgressBarVisible: Bool {
        self.totalGroups > 1 || self.totalExercisesInCurrentGroup != 1
    }

    var isExerciseInstructionsButtonVisible: Bool {
        (self.currentExercise.instructions?.isEmpty) != nil
    }

    var isFirstExercise: Bool {
        self.exerciseManager.isFirstExercise
    }

    var isLastExercise: Bool {
        self.exerciseManager.isLastExercise
    }

    func moveToNextExercise() {
        self.exerciseManager.moveToNextExercise()
        self.updateValues()
    }

    func moveToPreviousExercise() {
        self.exerciseManager.moveToPreviousExercise()
        self.updateValues()
    }

    func moveToActivityEnd() {
        self.isCurrentActivityCompleted = true
    }

    // MARK: Private

    private let exerciseManager: ActivityExerciseManager

    private var cancellables: Set<AnyCancellable> = []

    private func updateValues() {
        self.currentExercise = self.exerciseManager.currentExercise
        self.currentExerciseInterface = self.exerciseManager.currentExercise.interface
        self.currentGroupIndex = self.exerciseManager.currentGroupIndex
        self.totalGroups = self.exerciseManager.totalGroups
        self.currentExerciseIndexInCurrentGroup = self.exerciseManager.currentExerciseIndexInCurrentGroup
        self.totalExercisesInCurrentGroup = self.exerciseManager.totalExercisesInCurrentGroup
        self.currentExerciseSharedData = ExerciseSharedData(
            groupIndex: self.exerciseManager.currentGroupIndex,
            exerciseIndex: self.exerciseManager.currentExerciseIndexInCurrentGroup
        )
        self.completedExercisesSharedData.append(self.currentExerciseSharedData)

        self.subscribeToCurrentExerciseSharedDataUpdates()
    }

    private func subscribeToCurrentExerciseSharedDataUpdates() {
        self.currentExerciseSharedData.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink {
                if self.isReinforcerAnimationEnabled, case .completed = self.currentExerciseSharedData.state {
                    self.isReinforcerAnimationVisible = true
                } else {
                    self.isReinforcerAnimationVisible = false
                }
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - ActivityView

public struct ActivityView: View {
    // MARK: Lifecycle

    public init(activity: Activity) {
        self._viewModel = StateObject(wrappedValue: ActivityViewViewModel(activity: activity))
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
                            ExerciseInstructionsButton(instructions: self.viewModel.currentExercise.instructions ?? "no instructions")
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

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: ActivityViewViewModel

    @State private var opacity: Double = 1
    @State private var blurRadius: CGFloat = 0
    @State private var showScoreView: Bool = false
    @State private var isInfoSheetPresented: Bool = false

    private let robot = Robot.shared

    @ViewBuilder
    private var endOfActivityScoreView: some View {
        if self.viewModel.didCompleteActivitySuccessfully {
            // TODO: (@ladislas) change to non deprecated version
            ActivityViewDeprecated.SuccessView(percentage: self.viewModel.activityCompletionSuccessPercentage)
        } else {
            // TODO: (@ladislas) change to non deprecated version
            ActivityViewDeprecated.FailureView(percentage: self.viewModel.activityCompletionSuccessPercentage)
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

// MARK: - ActivityExerciseManager

public class ActivityExerciseManager {
    // MARK: Lifecycle

    public init(activity: Activity) {
        var copyOfActivity = activity

        if copyOfActivity.gameengine.shuffleExercises {
            copyOfActivity.exerciseGroups = copyOfActivity.exerciseGroups.map {
                ExerciseGroup(exercices: $0.exercices.shuffled())
            }
        }

        if copyOfActivity.gameengine.shuffleSequences {
            copyOfActivity.exerciseGroups.shuffle()
        }

        self.activity = copyOfActivity
    }

    // MARK: Public

    public var currentGroupIndex: Int = 0
    public var currentExerciseIndexInCurrentGroup: Int = 0

    public var totalGroups: Int {
        self.activity.exerciseGroups.count
    }

    public var totalExercisesInCurrentGroup: Int {
        self.activity.exerciseGroups[self.currentGroupIndex].exercices.count
    }

    public var currentExercise: Exercise {
        self.activity.exerciseGroups[self.currentGroupIndex].exercices[self.currentExerciseIndexInCurrentGroup]
    }

    public var isFirstExercise: Bool {
        self.currentExerciseIndexInCurrentGroup == 0 && self.currentGroupIndex == 0
    }

    public var isLastExercise: Bool {
        self.currentExerciseIndexInCurrentGroup == self.activity.exerciseGroups[self.currentGroupIndex].exercices.count - 1
            && self.currentGroupIndex == self.activity.exerciseGroups.count - 1
    }

    public func moveToNextExercise() {
        if self.currentExerciseIndexInCurrentGroup < self.activity.exerciseGroups[self.currentGroupIndex].exercices.count - 1 {
            self.currentExerciseIndexInCurrentGroup += 1
        } else if self.currentGroupIndex < self.activity.exerciseGroups.count - 1 {
            self.currentGroupIndex += 1
            self.currentExerciseIndexInCurrentGroup = 0
        }
    }

    public func moveToPreviousExercise() {
        if self.currentExerciseIndexInCurrentGroup > 0 {
            self.currentExerciseIndexInCurrentGroup -= 1
        } else if self.currentGroupIndex > 0 {
            self.currentGroupIndex -= 1
            self.currentExerciseIndexInCurrentGroup = self.activity.exerciseGroups[self.currentGroupIndex].exercices.count - 1
        }
    }

    // MARK: Private

    private let activity: Activity
}

#Preview {
    ActivityView(activity: Activity.mock)
}
