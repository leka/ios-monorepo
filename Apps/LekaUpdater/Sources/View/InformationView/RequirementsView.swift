// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - RequirementsView

struct RequirementsView: View {
    @State var viewModel: RequirementsViewModel

    var body: some View {
        VStack {
            Text(self.viewModel.requirementsInstructionsText)
                .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)

            HStack(alignment: .top) {
                RequirementView(
                    image: self.viewModel.chargingBasePluggedImage,
                    text: self.viewModel.chargingBasePluggedText,
                    stepNumber: 1
                )

                RequirementView(
                    image: self.viewModel.chargingBaseGreenLEDImage,
                    text: self.viewModel.chargingBaseGreenLEDText,
                    stepNumber: 2
                )

                RequirementView(
                    image: self.viewModel.robotBatteryMinimumLevelImage,
                    text: self.viewModel.robotBatteryMinimumLevelText,
                    stepNumber: 3
                )
            }
        }
        .padding()
    }
}

// MARK: - RequirementView

private struct RequirementView: View {
    let image: Image
    let text: AttributedString
    let stepNumber: Int

    var body: some View {
        VStack {
            self.image
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .strokeBorder(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor, lineWidth: 2)
                )

            Text("\(self.stepNumber)")
                .font(.title2)
                .foregroundColor(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                .padding()

            Text(self.text)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
        }
        .padding()
    }
}

// MARK: - RequirementsView_Previews

struct RequirementsView_Previews: PreviewProvider {
    static var previews: some View {
        RequirementsView(viewModel: RequirementsViewModel())
            .environment(\.locale, .init(identifier: "en"))

        RequirementsView(viewModel: RequirementsViewModel())
            .environment(\.locale, .init(identifier: "fr"))
    }
}
