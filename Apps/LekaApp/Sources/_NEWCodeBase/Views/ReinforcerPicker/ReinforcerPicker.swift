// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ReinforcerPicker

struct ReinforcerPicker: View {
    // MARK: Internal

    @Binding var carereceiver: Carereceiver

    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { number in
                Image(uiImage: self.rootOwnerViewModel.getReinforcerFor(index: number))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 50)
                    .padding(5)
                    .background(
                        Circle()
                            .stroke(self.styleManager.accentColor!, lineWidth: self.carereceiver.reinforcer == number ? 2 : 0)
                    )
                    .onTapGesture {
                        self.carereceiver.reinforcer = number
                    }
            }
        }
        .animation(.default, value: self.carereceiver.reinforcer)
    }

    // MARK: Private

    @ObservedObject private var rootOwnerViewModel = RootOwnerViewModel.shared
    @ObservedObject private var styleManager = StyleManager.shared
}

// MARK: - l10n.ReinforcerPicker

extension l10n {
    enum ReinforcerPicker {
        static let header = LocalizedString("lekaapp.reinforcer_picker.header", value: "Reinforcer choice", comment: "Reinforcer picker header")

        static let description = LocalizedString(
            "lekaapp.reinforcer_picker.avatar_choice_button",
            value: """
                Reinforcer is a repetitive light effect from the robot that you can activate to reward the user's behavior.
                If your robot is connected, you can test the reinforcers before choosing one.
                """,

            comment: " Reinforcer picker description"
        )
    }
}

#Preview {
    ReinforcerPicker(carereceiver: .constant(Carereceiver()))
}
