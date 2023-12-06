// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct CurrentGameInstructionView: View {
    @EnvironmentObject var activityVM: ActivityViewModel
    @ObservedObject var gameMetrics: GameMetrics
    @Environment(\.dismiss) var dismiss

    private var activityDetailHeader: some View {
        HStack {
            Spacer()
            Text(activityVM.currentActivity.title.localized())
                .font(gameMetrics.semi17)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(height: 70)
        .padding(.horizontal, 20)
    }

    private var resumeButton: some View {
        Button(
            action: {
                dismiss()
            },
            label: {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.2.circlepath")
                    Text("Reprendre")
                }
                .foregroundColor(.white)
            })
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Header color
                DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor.ignoresSafeArea()

                // Background Color
                DesignKitAsset.Colors.lekaLightGray.swiftUIColor.padding(.top, 70)

                VStack(spacing: 0) {
                    activityDetailHeader
                    InstructionsView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    resumeButton
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

struct CurrentGameInstructionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentGameInstructionView(gameMetrics: GameMetrics())
    }
}
