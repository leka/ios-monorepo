// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct AvatarPickerStore: View {
    // MARK: Internal

    @EnvironmentObject var metrics: UIMetrics

    @Binding var selected: String

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(AvatarSets.allCases, id: \.id) { category in
                self.makeAvatarCategoryRow(category: category.content)
                    .id(category.id)
            }
        }
    }

    // MARK: Private

    private func makeAvatarCategoryRow(category: AvatarCategory) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(category.category)
                .font(self.metrics.med16)
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                .padding(.leading, 40)
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHGrid(rows: [GridItem()], spacing: 50) {
                    ForEach(category.images, id: \.self) { item in
                        Button {
                            if self.selected == item {
                                self.selected = ""
                            } else {
                                self.selected = item
                            }
                        } label: {
                            AvatarButtonLabel(
                                image: .constant(item),
                                isSelected: .constant(self.selected == item)
                            )
                        }
                        .buttonStyle(NoFeedback_ButtonStyle())
                        .id(item)
                    }
                }
            }
            .frame(height: 179)
            ._safeAreaInsets(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        }
        .padding(.bottom, 10)
    }
}
