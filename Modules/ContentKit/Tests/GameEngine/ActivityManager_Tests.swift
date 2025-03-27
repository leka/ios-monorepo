// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Testing
import Yams

@testable import ContentKit

// MARK: - ActivityManager_Tests

@Suite struct ActivityManager_Tests {
    // MARK: Lifecycle

    init() async throws {
        self.payload = try YAMLDecoder().decode(ActivityPayload.self, from: self.kActivityYaml)
        self.activityManager = ActivityExercisesCoordinator(payload: self.payload)
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
    let activityManager: ActivityExercisesCoordinator

    @Test func initFromPayload() async throws {
        #expect(self.activityManager.numberOfGroups == 2)
        #expect(self.activityManager.numberOfExercisesInCurrentGroup == 3)
    }

    @Test func nextExercise() async throws {
        self.activityManager.nextExercise()

        #expect(self.activityManager.currentGroupIndex == 0)
        #expect(self.activityManager.currentExerciseIndex == 1)
    }

    @Test func nextExerciseAfterLast() async throws {
        self.activityManager.currentGroupIndex = 1
        self.activityManager.currentExerciseIndex = 2

        self.activityManager.nextExercise()

        #expect(self.activityManager.currentGroupIndex == 1)
        #expect(self.activityManager.currentExerciseIndex == 2)
    }

    @Test func previousExerciseAfterNext() async throws {
        self.activityManager.nextExercise()
        self.activityManager.previousExercise()

        #expect(self.activityManager.currentGroupIndex == 0)
        #expect(self.activityManager.currentExerciseIndex == 0)
    }

    @Test func previousExerciseWhenFirst() async throws {
        self.activityManager.previousExercise()

        #expect(self.activityManager.currentGroupIndex == 0)
        #expect(self.activityManager.currentExerciseIndex == 0)
    }

    @Test func isLastExercise() async throws {
        self.activityManager.currentGroupIndex = 1
        self.activityManager.currentExerciseIndex = 2

        #expect(self.activityManager.isLastExercise)
    }

    @Test func isFirstExercise() async throws {
        #expect(self.activityManager.isFirstExercise)
    }
}
