// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RequirementsView: View {
    @Binding var battery: Int
    @Binding var isCharging: Bool

    private var batteryImage: String {
        if battery >= 100 {
            return "battery.100"
        } else if battery >= 75 {
            return "battery.75"
        } else if battery >= 50 {
            return "battery.50"
        } else if battery >= 25 {
            return "battery.25"
        } else {
            return "battery.0"
        }
    }

    var body: some View {
        Image(systemName: batteryImage)
            .resizable()
            .scaledToFit()
            .frame(height: 50)
            .padding()
            .foregroundColor(battery >= 30 ? .green : .red)

        Image(systemName: "powerplug.fill")
            .resizable()
            .scaledToFit()
            .frame(height: 50)
            .padding()
            .foregroundColor(isCharging ? .green : .red)
    }
}

struct RobotUpdateAvailableView: View {
    @State private var isCharging = true

    var body: some View {
        HStack {
            RequirementsView(battery: .constant(74), isCharging: .constant(false))

            Button("MAJ") {
                // Start update here
            }
            .padding()
            .foregroundColor(.black)
            .background(.cyan)
            .cornerRadius(.infinity)
            .border(.black)
        }
        .padding()
    }
}

struct RobotUpdateAvailableView_Previews: PreviewProvider {
    static var previews: some View {
        RobotUpdateAvailableView()
    }
}
