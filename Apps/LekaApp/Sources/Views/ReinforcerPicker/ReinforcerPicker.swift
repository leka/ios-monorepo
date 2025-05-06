// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - ReinforcerPicker

struct ReinforcerPicker: View {
    // MARK: Internal

    var styleManager = StyleManager.shared
    @Binding var carereceiver: Carereceiver

    var body: some View {
        HStack {
            ForEach(Robot.Reinforcer.allCases, id: \.self) { reinforcer in
                Image(uiImage: reinforcer.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 50)
                    .padding(5)
                    .background(
                        Circle()
                            .stroke(self.styleManager.accentColor!, lineWidth: self.carereceiver.reinforcer == reinforcer ? 2 : 0)
                    )
                    .onTapGesture {
                        self.robot.run(reinforcer)
                        self.carereceiver.reinforcer = reinforcer
                    }
            }
        }
        .animation(.default, value: self.carereceiver.reinforcer)
    }

    // MARK: Private

    private let robot: Robot = .shared
}

// MARK: - l10n.ReinforcerPicker

extension l10n {
    enum ReinforcerPicker {
        static let header = LocalizedString(
            "lekaapp.reinforcer_picker.header",
            value: "Reinforcer choice",
            comment: "Reinforcer picker header"
        )

        static let description = LocalizedString(
            "lekaapp.reinforcer_picker.description",
            value: """
                Reinforcer is a repetitive light effect from the robot that you can activate to reward the user's behavior.
                If your robot is connected, you can test the reinforcers before choosing one.
                """,
            comment: "Reinforcer picker description"
        )
    }
}

#Preview {
    ReinforcerPicker(carereceiver: .constant(Carereceiver()))
}
