// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CurrentGameInstructionView

struct CurrentGameInstructionView: View {
    // MARK: Internal

    @EnvironmentObject var activityVM: ActivityViewModel
    @ObservedObject var gameMetrics: GameMetrics
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Header color
                DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor.ignoresSafeArea()

                // Background Color
                DesignKitAsset.Colors.lekaLightGray.swiftUIColor.padding(.top, 70)

                VStack(spacing: 0) {
                    self.activityDetailHeader
                    InstructionsView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    self.resumeButton
                }
            }
        }
        .preferredColorScheme(.light)
    }

    // MARK: Private

    private var activityDetailHeader: some View {
        HStack {
            Spacer()
            Text(self.activityVM.currentActivity.title.localized())
                .font(.headline)
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
                self.dismiss()
            },
            label: {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.2.circlepath")
                    Text("Reprendre")
                }
                .foregroundColor(.white)
            }
        )
    }
}

// MARK: - CurrentGameInstructionView_Previews

struct CurrentGameInstructionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentGameInstructionView(gameMetrics: GameMetrics())
    }
}
