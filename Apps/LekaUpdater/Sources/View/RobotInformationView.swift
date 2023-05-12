// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotInformationView: View {
    var body: some View {
        List {
            Text("Nom: ")
            Text("N° série: ")
            Text("Battery: ")
            Text("Version: ")
        }
    }
}

struct RobotInformationView_Previews: PreviewProvider {
    static var previews: some View {
        RobotInformationView()
    }
}
