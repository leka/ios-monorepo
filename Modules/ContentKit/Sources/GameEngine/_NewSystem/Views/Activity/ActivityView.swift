// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import LocalizationKit
import SwiftUI

// MARK: - ActivityView

public struct ActivityView: View {
    // MARK: Lifecycle

    public init(activity: Activity, coordinator: ActivityCoordinator) {
        self.activity = activity
        self.activityCoordinator = coordinator
    }

    // MARK: Public

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 10) {
                if self.activityCoordinator.numberOfExercisesInCurrentGroup > 1 || self.activityCoordinator.numberOfGroups > 1 {
                    VStack {
                        ActivityProgressBar(coordinator: self.activityCoordinator)
                    }
                }

                self.activityCoordinator.currentExerciseView
            }
            .compositingGroup()
            .id(self.activityCoordinator.currentExerciseIndex)
            .disabled(self.activityCoordinator.isExerciseCompleted)
            .blur(radius: self.blurRadius)
            .onChange(of: self.isReinforcerPresented) {
                if self.isReinforcerPresented, self.activityCoordinator.isReinforcerAnimationEnabled {
                    withAnimation(.easeInOut.delay(0.5)) {
                        self.blurRadius = 20
                    }
                } else {
                    self.blurRadius = 0
                }
            }

            if self.isReinforcerPresented, self.activityCoordinator.isReinforcerAnimationEnabled {
                ReinforcerView(isLastExercise: self.activityCoordinator.isLastExercise,
                               onContinue: {
                                   self.activityCoordinator.nextExercise()
                               },
                               onDismiss: {
                                   self.isReinforcerPresented = false
                               })
            }

            if self.activityCoordinator.isExerciseCompleted, !self.isReinforcerPresented || !self.activityCoordinator.isReinforcerAnimationEnabled {
                ContinueButton {
                    self.activityCoordinator.nextExercise()
                }
                .transition(
                    .asymmetric(
                        insertion: .opacity.animation(.snappy.delay(0.75)),
                        removal: .identity
                    )
                )
            }
        }
        .frame(maxWidth: .infinity)
        .background(.lkBackground)
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationTitle(self.activity.details.title)
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
                        self.activityCoordinator.isReinforcerAnimationEnabled.toggle()
                    } label: {
                        if self.activityCoordinator.isReinforcerAnimationEnabled {
                            Image(systemName: "livephoto")
                        } else {
                            Image(systemName: "livephoto.slash")
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.activityCoordinator.previousExercise()
                    } label: {
                        Image(systemName: "arrow.backward")
                    }
                    .disabled(self.activityCoordinator.isFirstExercise)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.activityCoordinator.nextExercise()
                    } label: {
                        Image(systemName: "arrow.forward")
                    }
                    .disabled(self.activityCoordinator.isLastExercise)
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
        .alert(String(l10n.ActivityView.QuitActivityAlert.title.characters), isPresented: self.$isAlertPresented) {
            Button(String(l10n.ActivityView.QuitActivityAlert.cancelButtonLabel.characters), role: .cancel, action: {
                self.isAlertPresented = false
            })
            Button(String(l10n.ActivityView.QuitActivityAlert.quitButtonLabel.characters), role: .destructive, action: {
                self.dismiss()
            })
        } message: {
            Text(l10n.ActivityView.QuitActivityAlert.message)
        }
        .sheet(isPresented: self.$isInfoSheetPresented) {
            self.activityInformationSheet
        }
        .fullScreenCover(isPresented: self.$isActivitySummaryPresented) {
            self.endOfActivityScoreView
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                logGEK.debug("Activity did start")
                self.activityCoordinator.activityEvent.send(.didStart)
            }
        }
        .onReceive(self.activityCoordinator.activityEvent) { event in
            switch event {
                case .didStart:
                    self.isActivitySummaryPresented = false
                    self.isReinforcerPresented = false
                case .didEnd:
                    self.isReinforcerPresented = false
                    self.isActivitySummaryPresented = true
            }
        }
        .onChange(of: self.activityCoordinator.isExerciseCompleted) {
            self.isReinforcerPresented = self.activityCoordinator.isExerciseCompleted
        }
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    @State private var blurRadius: CGFloat = 0
    @State private var isAlertPresented: Bool = false
    @State private var isInfoSheetPresented: Bool = false
    @State private var isActivitySummaryPresented: Bool = false
    @State private var isReinforcerPresented: Bool = false

    private var activityCoordinator: ActivityCoordinator
    private let activity: Activity

    @ViewBuilder
    private var endOfActivityScoreView: some View {
        if self.didCompleteActivitySuccessfully {
            SuccessView(percentage: self.activityCompletionSuccessPercentage)
        } else {
            FailureView(percentage: self.activityCompletionSuccessPercentage)
        }
    }

    @ViewBuilder
    private var activityInformationSheet: some View {
        if let detailsView = InfoDetailsView(
            CurationItemModel(id: self.activity.id, name: self.activity.details.title, contentType: .activity)
        ) {
            detailsView
                .logEventScreenView(
                    screenName: "activity_details",
                    context: .sheet,
                    parameters: [
                        "lk_activity_id": "\(self.activity.details.title)-\(self.activity.id)",
                    ]
                )
        } else {
            Text(l10n.ActivityView.InfoSheet.unavailableMessage)
                .padding()
        }
    }

    private var didCompleteActivitySuccessfully: Bool {
        guard self.numberOfApplicableExercises > 0 else { return false }

        let minimalSuccessRatio = 0.8
        return Double(self.numberOfSuccessfulExercises) >= Double(self.numberOfApplicableExercises) * minimalSuccessRatio
    }

    private var activityCompletionSuccessPercentage: Double {
        guard self.numberOfApplicableExercises > 0 else { return 0 }

        return (Double(self.numberOfSuccessfulExercises) / Double(self.numberOfApplicableExercises)) * 100.0
    }

    private var numberOfSuccessfulExercises: Int {
        self.applicableCompletedExercises.filter { completion in
            completion.level == .excellent || completion.level == .good
        }.count
    }

    private var completedExercises: [(level: ExerciseEvaluationLevel, data: ExerciseCompletionData?)] {
        self.activityCoordinator.exercisesCompletionData.flatMap { $0 }
    }

    private var applicableCompletedExercises: [(level: ExerciseEvaluationLevel, data: ExerciseCompletionData?)] {
        self.completedExercises.filter { $0.level != .notApplicable }
    }

    private var numberOfApplicableExercises: Int {
        self.applicableCompletedExercises.count
    }
}

#if DEBUG

    let kActivityYaml = """
        uuid: F8C90919AF204155A170D3957BABE7D6
        name: TestActivityMock
        exercises_payload:
          options:
            shuffle_exercises: false
            shuffle_groups: false

          exercise_groups:
            - group:
                - instructions:
                    - locale: fr_FR
                      value: Touche les emojis du chien
                    - locale: en_US
                      value: Tap the dog emojis
                  interface: touchToSelect
                  gameplay: findTheRightAnswers
                  payload:
                    shuffle_choices: true
                    choices:
                      - value: 🐶
                        type: emoji
                        is_right_answer: true
                      - value: 🐶
                        type: emoji
                        is_right_answer: true
                      - value: 🐱
                        type: emoji
                      - value: 🐱
                        type: emoji
                      - value: 🐷
                        type: emoji
                      - value: 🐷
                        type: emoji
                - instructions:
                    - locale: fr_FR
                      value: Touche les emojis qui sont identiques
                    - locale: en_US
                      value: Tap the emojis that are the same
                  interface: touchToSelect
                  gameplay: associateCategories
                  payload:
                    shuffle_choices: true
                    choices:
                      - value: 🐶
                        type: emoji
                        category: catA
                      - value: 🐶
                        type: emoji
                        category: catA
                      - value: 🐱
                        type: emoji
                        category: catB
                      - value: 🐱
                        type: emoji
                        category: catB
                      - value: 🐷
                        type: emoji
                        category: catC
                      - value: 🐷
                        type: emoji
                        category: catC
        """

    import Yams

    #Preview {
        var cancellables = Set<AnyCancellable>()

        NavigationStack {
            if let activity = Activity(yaml: kActivityYaml) {
                let coordinator = ActivityCoordinator(payload: activity.payload)

                ActivityView(activity: activity, coordinator: coordinator)
                    .onAppear {
                        coordinator.activityEvent
                            .receive(on: DispatchQueue.main)
                            .sink { event in
                                switch event {
                                    case .didStart:
                                        logGEK.debug("Publisher - Activity did start")

                                    case .didEnd:
                                        logGEK.debug("Publisher - Activity did end")
                                }
                            }
                            .store(in: &cancellables)
                    }

            } else {
                Text("Invalid activity")
            }
        }
    }

#endif
