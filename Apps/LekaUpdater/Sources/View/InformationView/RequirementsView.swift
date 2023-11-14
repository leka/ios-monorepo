// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RequirementsView: View {
    @StateObject var viewModel: RequirementsViewModel

    var body: some View {
        VStack {
            Text(viewModel.requirementsInstructionsText)
                .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)

            HStack(alignment: .top) {
                RequirementView(
                    image: viewModel.chargingBasePluggedImage,
                    text: viewModel.chargingBasePluggedText,
                    stepNumber: 1)

                RequirementView(
                    image: viewModel.chargingBaseGreenLEDImage,
                    text: viewModel.chargingBaseGreenLEDText,
                    stepNumber: 2)

                RequirementView(
                    image: viewModel.robotBatteryMinimumLevelImage,
                    text: viewModel.robotBatteryMinimumLevelText,
                    stepNumber: 3)
            }
        }
        .padding()
    }
}

private struct RequirementView: View {
    let image: Image
    let text: AttributedString
    let stepNumber: Int

    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .strokeBorder(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor, lineWidth: 2)
                )

            Text("\(stepNumber)")
                .font(.title2)
                .foregroundColor(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                .padding()

            Text(text)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
        }
        .padding()
    }
}

struct RequirementsView_Previews: PreviewProvider {
    static var previews: some View {
        RequirementsView(viewModel: RequirementsViewModel())
            .environment(\.locale, .init(identifier: "en"))

        RequirementsView(viewModel: RequirementsViewModel())
            .environment(\.locale, .init(identifier: "fr"))
    }
}
