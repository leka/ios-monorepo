// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

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
