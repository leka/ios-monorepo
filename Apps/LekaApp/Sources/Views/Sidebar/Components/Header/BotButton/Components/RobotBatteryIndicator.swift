// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotBatteryIndicator: View {

    @Binding var level: Double
    @Binding var charging: Bool

    @State private var opacity: Double = 1

    var body: some View {
        Image(systemName: imageGivenValue())
            .symbolRenderingMode(.palette)
            .foregroundStyle(primaryColorGivenValue(), .tertiary)
            .imageScale(.large)
            .font(.system(size: 13))
            .padding([.vertical, .trailing], 5)
            .opacity(opacity)
            .animation(level < 10 ? .easeIn(duration: 1.0).repeatForever(autoreverses: false) : .easeIn, value: opacity)
            .animation(.easeIn(duration: 0.3), value: imageGivenValue())
            .animation(.easeIn(duration: 0.3), value: primaryColorGivenValue())
            .onChange(
                of: level,
                perform: { value in
                    if value < 10 {
                        opacity = 0
                    } else {
                        opacity = 1
                    }
                }
            )
    }

    private func imageGivenValue() -> String {
        if level < 25 {
            return charging ? "battery.100.bolt" : "battery.25"
        } else if 25..<50 ~= level {
            return charging ? "battery.100.bolt" : "battery.25"
        } else if 50..<75 ~= level {
            return charging ? "battery.100.bolt" : "battery.50"
        } else if 75..<100 ~= level {
            return charging ? "battery.100.bolt" : "battery.75"
        } else {
            return charging ? "battery.100.bolt" : "battery.100"
        }
    }

    private func primaryColorGivenValue() -> Color {
        if level < 25 {
            return .red
        } else if 25..<50 ~= level {
            return .yellow
        } else {
            return .green
        }
    }
}

struct RobotBatteryIndicator_Previews: PreviewProvider {
    static var previews: some View {
        RobotBatteryIndicator(level: .constant(98), charging: .constant(true))
    }
}
