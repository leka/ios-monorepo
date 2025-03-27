// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - SpecializedExercises

struct SpecializedExercises: View {
    var body: some View {
        Text("Specialized")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kDanceFreezeYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Dance Freeze")
                        .navigationBarTitleDisplayMode(.inline)

                } label: {
                    ExerciseNavigationButtonLabel(text: "Dance Freeze", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kMusicalInstrumentYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Musical Instruments")
                        .navigationBarTitleDisplayMode(.inline)

                } label: {
                    ExerciseNavigationButtonLabel(text: "Musical Instruments", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kMediumSuperSimonYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Super Simon")
                        .navigationBarTitleDisplayMode(.inline)

                } label: {
                    ExerciseNavigationButtonLabel(text: "Super Simon", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kMelodyYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Melody")
                        .navigationBarTitleDisplayMode(.inline)

                } label: {
                    ExerciseNavigationButtonLabel(text: "Melody", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kHideAndSeekYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("HideAndSeek")
                        .navigationBarTitleDisplayMode(.inline)

                } label: {
                    ExerciseNavigationButtonLabel(text: "HideAndSeek", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kDiscoverLekaYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Discover Leka")
                        .navigationBarTitleDisplayMode(.inline)

                } label: {
                    ExerciseNavigationButtonLabel(text: "Discover Leka", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kColorMediatorYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Color Mediator")
                        .navigationBarTitleDisplayMode(.inline)

                } label: {
                    ExerciseNavigationButtonLabel(text: "Color Mediator", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kColorMusicPadYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Color Music Pad")
                        .navigationBarTitleDisplayMode(.inline)

                } label: {
                    ExerciseNavigationButtonLabel(text: "Color Music Pad", color: .indigo)
                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kGamepadArrowPadYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Gamepad Arrow Pad")
                        .navigationBarTitleDisplayMode(.inline)

                } label: {
                    ExerciseNavigationButtonLabel(text: "Gamepad Arrow Pad", color: .indigo)
                }
//
//                NavigationLink {
//                    let exercise = NewExercise(yaml: ExerciseYAMLs.kGamepadColorPadYaml)!
//                    ExerciseCoordinator(exercise: exercise).exerciseView
//                        .navigationTitle("Gamepad Color Pad")
//                        .navigationBarTitleDisplayMode(.inline)
//
//                } label: {
//                    ExerciseNavigationButtonLabel(text: "Gamepad Color Pad", color: .indigo)
//                }

                NavigationLink {
                    let exercise = NewExercise(yaml: ExerciseYAMLs.kGamepadJoystickColorPadYaml)!
                    CurrentExerciseCoordinator(exercise: exercise).exerciseView
                        .navigationTitle("Gamepad Joystick Color Pad")
                        .navigationBarTitleDisplayMode(.inline)

                } label: {
                    ExerciseNavigationButtonLabel(text: "Gamepad Joystick Color Pad", color: .indigo)
                }
            }
        }
    }
}

#Preview {
    SpecializedExercises()
}
