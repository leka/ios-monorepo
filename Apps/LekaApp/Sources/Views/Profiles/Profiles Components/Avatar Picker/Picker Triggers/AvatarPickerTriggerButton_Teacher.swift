//
//  AvatarPickerTriggerButton_Teacher.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 15/3/23.
//

import SwiftUI

struct AvatarPickerTriggerButton_Teachers: View {

	@EnvironmentObject var company: CompanyViewModel

	@Binding var navigate: Bool

	var body: some View {
		Button(action: {
			navigate.toggle()
		}, label: {
			VStack(spacing: 10) {
				AvatarTriggerImageView(img: company.getSelectedProfileAvatar(.teacher))
				AvatarTriggerCTAView()
			}
		})
		.buttonStyle(NoFeedback_ButtonStyle())
	}
}
