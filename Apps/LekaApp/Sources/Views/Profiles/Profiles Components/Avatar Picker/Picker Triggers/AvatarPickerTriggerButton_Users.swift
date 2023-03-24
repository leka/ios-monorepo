    //
    //  AvatarPickerTriggerButton.swift
    //  LekaTestBucket
    //
    //  Created by Mathieu Jeannot on 19/12/22.
    //

import SwiftUI

struct AvatarPickerTriggerButton_Users: View {
	
	@EnvironmentObject var company: CompanyViewModel
	
	@Binding var navigate: Bool
	
	var body: some View {
		Button(action: {
			navigate.toggle()
		}, label: {
			VStack(spacing: 10) {
				AvatarTriggerImageView(img: company.getSelectedProfileAvatar(.user))
				AvatarTriggerCTAView()
			}
		})
		.buttonStyle(NoFeedback_ButtonStyle())
	}
}
