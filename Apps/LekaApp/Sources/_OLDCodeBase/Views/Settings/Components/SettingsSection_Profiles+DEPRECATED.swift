// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SettingsSection_ProfilesDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Section {
            Group {
                self.avatarsRow(.teacher)
                self.avatarsRow(.user)
            }
            .frame(maxHeight: 52)
        } header: {
            Text("Profils")
                .font(.body)
                .headerProminence(.increased)
        }
    }

    // MARK: Private

    private func avatar(_ name: String) -> some View {
        Image(name, bundle: Bundle(for: DesignKitResources.self))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: 30)
            .background(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
            .clipShape(Circle())
            .overlay(Circle().stroke(.white, lineWidth: 2))
    }

    private func remainingProfiles(_ remainder: Int) -> some View {
        Circle()
            .fill(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
            .frame(maxWidth: 30)
            .overlay(
                Text("+\(remainder)")
                    .foregroundColor(.white)
                    .font(.footnote)
                    .clipShape(Circle())
            )
            .overlay(Circle().stroke(.white, lineWidth: 2))
    }

    private func avatarsRow(_ type: UserTypeDeprecated) -> some View {
        LabeledContent {
            HStack(spacing: -10) {
                ForEach(self.company.getAllAvatarsOf(type).prefix(10), id: \.self) { item in
                    self.avatar(item.first!.value)
                }
                if self.company.getAllAvatarsOf(type).count > 10 {
                    let remainder: Int = self.company.getAllAvatarsOf(type).count - 10
                    self.remainingProfiles(remainder)
                }
                Spacer()
            }
            .frame(minWidth: 320, maxWidth: 320)
        } label: {
            Text(
                "Profils \(type == .teacher ? "accompagnants" : "utilisateurs") (\(self.company.getAllAvatarsOf(type).count))"
            )
            .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
        }
    }
}
