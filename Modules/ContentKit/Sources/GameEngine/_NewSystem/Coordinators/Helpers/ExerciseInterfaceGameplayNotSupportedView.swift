// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - ExerciseInterfaceGameplayNotSupportedView

struct ExerciseInterfaceGameplayNotSupportedView: View {
    // MARK: Lifecycle

    init(interface: NewExerciseInterface.GeneralInterface, gameplay: NewExerciseGameplay? = nil) {
        logGEK.error("Interface \(interface) and gameplay \(gameplay?.rawValue ?? "empty") combination not supported.")
        self.interface = interface
        self.gameplay = gameplay
    }

    // MARK: Internal

    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(.red)

            Text("Interface + Gameplay \n not supported")
                .font(.title)

            Text(
                "Interface: \(self.interface.rawValue) \n Gameplay: \(self.gameplay?.rawValue ?? "empty")"
            )
            .font(.subheadline)
        }
        .multilineTextAlignment(.center)
    }

    // MARK: Private

    private let interface: NewExerciseInterface.GeneralInterface
    private let gameplay: NewExerciseGameplay?
}

#if DEBUG
    #Preview {
        ExerciseInterfaceGameplayNotSupportedView(interface: .dragAndDropGrid, gameplay: .openPlay)
    }
#endif
