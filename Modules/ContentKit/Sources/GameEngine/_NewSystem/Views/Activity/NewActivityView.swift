// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - NewActivityView

public struct NewActivityView: View {
    // MARK: Lifecycle

    public init(activity: NewActivity, coordinator: ActivityCoordinator) {
        self.activity = activity
        self.activityCoordinator = coordinator
    }

    // MARK: Public

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 10) {
                VStack {
                    NewActivityProgressBar(coordinator: self.activityCoordinator)
                }

                self.activityCoordinator.currentExerciseView
                    .id(self.activityCoordinator.currentExerciseIndex)
            }
            .disabled(self.activityCoordinator.isExerciseCompleted)
            .blur(radius: self.blurRadius)
            .onChange(of: self.isReinforcerPresented) {
                if self.isReinforcerPresented {
                    withAnimation(.easeInOut.delay(0.5)) {
                        self.blurRadius = 20
                    }
                } else {
                    self.blurRadius = 0
                }
            }

            if self.isReinforcerPresented {
                ReinforcerView(isLastExercise: self.activityCoordinator.isLastExercise,
                               onContinue: {
                                   self.activityCoordinator.nextExercise()
                               },
                               onDismiss: {
                                   self.isReinforcerPresented = false
                               })
            }

            if self.activityCoordinator.isExerciseCompleted, !self.isReinforcerPresented {
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
        .navigationTitle(self.activity.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    // TODO: (@HPezz) Add alert to prevent for misclick
                    self.dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                }
            }

            #if DEVELOPER_MODE
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: (@dev-ios) implement reinforcer toggle
                    } label: {
                        Image(systemName: "livephoto")
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
                    // TODO: (@dev-ios) implement activity information sheet toggle
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                logGEK.debug("Activity did start")
                self.activityCoordinator.activityEvent.send(.didStart)
            }
        }
        .onChange(of: self.activityCoordinator.isExerciseCompleted) {
            self.isReinforcerPresented = self.activityCoordinator.isExerciseCompleted
        }
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    @State private var blurRadius: CGFloat = 0
    @State private var isReinforcerPresented: Bool = false

    private var activityCoordinator: ActivityCoordinator
    private let activity: NewActivity
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
            if let activity = NewActivity(yaml: kActivityYaml) {
                let coordinator = ActivityCoordinator(payload: activity.payload)

                NewActivityView(activity: activity, coordinator: coordinator)
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
