//
//  AvatarPicker_Users.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 15/3/23.
//

import SwiftUI

struct AvatarPicker_Users: View {

	@EnvironmentObject var company: CompanyViewModel
	@EnvironmentObject var metrics: UIMetrics
	@EnvironmentObject var viewRouter: ViewRouter

	@State private var selected: String = ""

	var body: some View {
		ZStack {
			Color.white.edgesIgnoringSafeArea(.top)

			AvatarPickerStore(selected: $selected)
				.onAppear {
					selected = company.bufferUser.avatar
				}
				._safeAreaInsets(EdgeInsets(top: 40, leading: 0, bottom: 20, trailing: 0))
				.navigationBarTitleDisplayMode(.inline)
				.navigationBarBackButtonHidden(true)
				.toolbar {
					ToolbarItem(placement: .principal) { AvatarPicker_NavigationTitle() }
					ToolbarItem(placement: .navigationBarLeading) { AvatarPicker_AdaptiveBackButton() }
					ToolbarItem(placement: .navigationBarTrailing) {
						AvatarPicker_ValidateButton(selected: $selected, action: {
							company.setBufferAvatar(selected, for: .user)
						})
					}
				}
		}
		.toolbarBackground(viewRouter.currentPage == .profiles ? .visible : .automatic, for: .navigationBar)
		.preferredColorScheme(.light)
	}
}
