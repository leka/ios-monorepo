// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Testing
import Yams

@testable import ContentKit

// MARK: - ActivityManager_Tests

@Suite struct ActivityCoordinator_Tests {
    // MARK: Lifecycle

    init() async throws {
        self.payload = try YAMLDecoder().decode(ActivityPayload.self, from: self.kActivityYaml)
        self.activityCoordinator = ActivityCoordinator(payload: self.payload)
    }

    // MARK: Internal

    let kActivityYaml = """
          options:
            shuffle_exercises: false
            shuffle_groups: false

          exercise_groups:
            - group:
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
            - group:
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

    let payload: ActivityPayload
    let activityCoordinator: ActivityCoordinator

    @Test func initFromPayload() async throws {
        #expect(self.activityCoordinator.numberOfGroups == 2)
        #expect(self.activityCoordinator.numberOfExercisesInCurrentGroup == 3)
    }

    @Test func nextExercise() async throws {
        self.activityCoordinator.nextExercise()

        #expect(self.activityCoordinator.currentGroupIndex == 0)
        #expect(self.activityCoordinator.currentExerciseIndex == 1)
    }

    @Test func nextExerciseAfterLast() async throws {
        self.activityCoordinator.currentGroupIndex = 1
        self.activityCoordinator.currentExerciseIndex = 2

        self.activityCoordinator.nextExercise()

        #expect(self.activityCoordinator.currentGroupIndex == 1)
        #expect(self.activityCoordinator.currentExerciseIndex == 2)
    }

    @Test func previousExerciseAfterNext() async throws {
        self.activityCoordinator.nextExercise()
        self.activityCoordinator.previousExercise()

        #expect(self.activityCoordinator.currentGroupIndex == 0)
        #expect(self.activityCoordinator.currentExerciseIndex == 0)
    }

    @Test func previousExerciseWhenFirst() async throws {
        self.activityCoordinator.previousExercise()

        #expect(self.activityCoordinator.currentGroupIndex == 0)
        #expect(self.activityCoordinator.currentExerciseIndex == 0)
    }

    @Test func isLastExercise() async throws {
        self.activityCoordinator.currentGroupIndex = 1
        self.activityCoordinator.currentExerciseIndex = 2

        #expect(self.activityCoordinator.isLastExercise)
    }

    @Test func isFirstExercise() async throws {
        #expect(self.activityCoordinator.isFirstExercise)
    }
}
