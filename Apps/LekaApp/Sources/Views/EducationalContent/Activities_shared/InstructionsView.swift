// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// TODO(@ladislas): reimport when Down is fixed
// import Down
import DesignKit
import SwiftUI

// MARK: - InstructionsView

struct InstructionsView: View {
    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            //			instructions_OLD
            instructionsMarkdownView
        }
        .safeAreaInset(edge: .top) {
            instructionTitle
        }
    }

    @ViewBuilder
    private var instructionsMarkdownView: some View {
        //		Text(activityVM.getInstructions())
        DownAttributedString(text: activityVM.getInstructions())
            //		MarkdownRepresentable(height: .constant(.zero))
            .environmentObject(MarkdownObservable(text: activityVM.getInstructions()))
            .padding()
            .frame(minWidth: 450, maxWidth: 550)
    }

    private var instructionTitle: some View {
        HStack {
            Spacer()
            Text("DESCRIPTION & INSTALLATION")
                .font(metrics.reg18)
                .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor.opacity(0.8))
                .padding(.vertical, 22)
            Spacer()
        }
        .padding(.top, 30)
        .background(DesignKitAsset.Colors.lekaLightGray.swiftUIColor)
    }
}

// MARK: - InstructionsView_Previews

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
            .environmentObject(UIMetrics())
            .environmentObject(ActivityViewModel())
    }
}
