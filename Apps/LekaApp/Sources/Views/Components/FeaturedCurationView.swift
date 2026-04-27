// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import ContentKit
import SwiftUI

// MARK: - FeaturedCurationView

public struct FeaturedCurationView: View {
    // MARK: Public

    public var body: some View {
        if let item = self.section.items.first,
           item.contentType == .curation,
           let curation = CategoryCuration(id: item.id)
        {
            NavigationLink(destination:
                AnyView(self.navigation.curationDestination(item)))
            {
                HStack(spacing: 24) {
                    self.icon(for: curation)
                        .frame(width: 92, height: 92)
                        .padding(22)
                        .background(.white.opacity(0.18), in: RoundedRectangle(cornerRadius: 28))

                    VStack(alignment: .leading, spacing: 12) {
                        Text(self.section.details.title)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)

                        if self.section.details.description != "" {
                            Text(self.section.details.description)
                                .font(.title3)
                                .foregroundStyle(.white.opacity(0.9))
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if self.section.details.subtitle != "" {
                            HStack(spacing: 8) {
                                Text(self.section.details.subtitle)
                                    .font(.headline.bold())

                                Image(systemName: "arrow.right")
                                    .font(.headline.bold())
                            }
                            .foregroundStyle(curation.color)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(.white, in: Capsule())
                            .padding(.top, 4)
                        }
                    }

                    Spacer(minLength: 0)
                }
                .padding(32)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [curation.color, curation.color.opacity(0.78)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: RoundedRectangle(cornerRadius: 32)
                )
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundStyle(.white.opacity(0.12))
                        .padding(28)
                }
                .padding(.horizontal)
            }
            .buttonStyle(.plain)
            .simultaneousGesture(TapGesture().onEnded {
                AnalyticsManager.logEventSelectContent(
                    type: .curation,
                    id: item.id,
                    name: item.name,
                    origin: self.navigation.selectedCategory?.rawValue
                )
            })
        }
    }

    // MARK: Internal

    let section: CategoryCuration.Section

    // MARK: Private

    @State private var navigation: Navigation = .shared

    @ViewBuilder
    private func icon(for curation: CategoryCuration) -> some View {
        if let icon = UIImage(named: "\(curation.icon).skill.icon.png", in: .module, with: nil) {
            Image(uiImage: icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
        } else {
            Image(systemName: curation.icon)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    let homeCuration = ContentKit.allCurations[MainCurations.home.rawValue]!

    return ScrollView {
        FeaturedCurationView(section: homeCuration.sections[0])
    }
}
