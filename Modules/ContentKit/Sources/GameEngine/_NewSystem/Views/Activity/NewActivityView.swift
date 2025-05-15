// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - NewActivityView

public struct NewActivityView: View {
    // MARK: Lifecycle

    public init(activity: NewActivity, manager: ActivityExercisesCoordinator) {
        self.activity = activity
        self.activityManager = manager
    }

    // MARK: Public

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 10) {
                VStack {
                    NewActivityProgressBar(manager: self.activityManager)
                }

                self.activityManager.currentExerciseView
            }
        }
        .frame(maxWidth: .infinity)
        .background(.lkBackground)
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationTitle(self.activity.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: (@dev-ios) implement reinforcer toggle
                } label: {
                    Image(systemName: "livephoto")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.activityManager.previousExercise()
                } label: {
                    Image(systemName: "arrow.backward")
                }
                .disabled(self.activityManager.isFirstExercise)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.activityManager.nextExercise()
                } label: {
                    Image(systemName: "arrow.forward")
                }
                .disabled(self.activityManager.isLastExercise)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: (@dev-ios) implement activity information sheet toggle
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                logGEK.debug("Activity started")
                self.activityManager.activityStage.send(.start)
            }
        }
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    // MARK: Private

    private var activityManager: ActivityExercisesCoordinator

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
                - instructions:
                    - locale: fr_FR
                      value: Glisse et dépose les emojis identiques ensemble
                    - locale: en_US
                      value: Drag and drop the same emojis together
                  interface: dragAndDropGrid
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
                - instructions:
                    - locale: fr_FR
                      value: Glisse et dépose les émojis dans la zone correspondante
                    - locale: en_US
                      value: Drag and drop the emojis in the correct zone
                  interface: dragAndDropGridWithZones
                  gameplay: associateCategories
                  payload:
                    shuffle_choices: true
                    choices:
                      - value: 🐶
                        type: emoji
                        category: catA
                        is_dropzone: true
                      - value: 🐶
                        type: emoji
                        category: catA
                      - value: 🐱
                        type: emoji
                        category: catB
                        is_dropzone: true
                      - value: 🐱
                        type: emoji
                        category: catB
                      - value: 🐷
                        type: emoji
                        category: catC
                      - value: 🐷
                        type: emoji
                        category: catC
            - group:
                - instructions:
                    - locale: fr_FR
                      value: Touche les emojis qui sont identiques
                    - locale: en_US
                      value: Tap the emojis that are the same
                  interface: dragAndDropGrid
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
                - instructions:
                    - locale: fr_FR
                      value: Touche les emojis qui sont identiques
                    - locale: en_US
                      value: Tap the emojis that are the same
                  interface: dragAndDropGridWithZones
                  gameplay: associateCategories
                  payload:
                    shuffle_choices: true
                    choices:
                      - value: 🐶
                        type: emoji
                        category: catA
                        is_dropzone: true
                      - value: 🐶
                        type: emoji
                        category: catA
                      - value: 🐱
                        type: emoji
                        category: catB
                        is_dropzone: true
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
                let manager = ActivityExercisesCoordinator(payload: activity.payload)

                NewActivityView(activity: activity, manager: manager)
                    .onAppear {
                        manager.activityStage
                            .receive(on: DispatchQueue.main)
                            .sink { stage in
                                switch stage {
                                    case .start:
                                        logGEK.debug("Publisher - Activity started")

                                    case .end:
                                        logGEK.debug("Publisher - Activity ended")
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
