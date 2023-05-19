// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RequirementsView: View {
    @StateObject var viewModel: RequirementsViewModel

    var body: some View {
        VStack {
            viewModel.requirementsImage
                .resizable()
                .scaledToFit()
                .frame(height: 150)

            Text("Le robot doit être en charge et sa batterie à au moins 30%.")
                .bold()
                .foregroundColor(.red)
        }
    }
}

struct RequirementsView_Previews: PreviewProvider {
    @StateObject static var robot = DummyRobotModel()
    @StateObject static var viewModel = RequirementsViewModel(robot: robot)

    static var previews: some View {
        RequirementsView(viewModel: viewModel)
    }
}
