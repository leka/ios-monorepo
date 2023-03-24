//
//  AvatarPickerStore.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 20/3/23.
//

import SwiftUI

struct AvatarPickerStore: View {

	@EnvironmentObject var metrics: UIMetrics

	@Binding var selected: String

	var body: some View {
		ScrollView(.vertical, showsIndicators: true) {
			ForEach(AvatarSets.allCases, id: \.id) { category in
				makeAvatarCategoryRow(category: category.content)
					.id(category.id)
			}
		}
	}

	private func makeAvatarCategoryRow(category: AvatarCategory) -> some View {
		VStack(alignment: .leading, spacing: 10) {
			Text(category.category)
				.font(metrics.med16)
				.foregroundColor(.accentColor)
				.padding(.leading, 40)
			ScrollView(.horizontal, showsIndicators: true) {
				LazyHGrid(rows: [GridItem()], spacing: 50) {
					ForEach(category.images, id: \.self) { item in
						Button {
							if selected == item {
								selected = ""
							} else {
								selected = item
							}
						} label: {
							AvatarButtonLabel(image: .constant(item),
											  isSelected: .constant(selected == item))
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
