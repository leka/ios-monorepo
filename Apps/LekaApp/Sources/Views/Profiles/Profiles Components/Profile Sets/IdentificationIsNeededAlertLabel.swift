//
//  IdentificationIsNeededAlertLabel.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 15/3/23.
//

import SwiftUI

struct IdentificationIsNeededAlertLabel: View {

	@EnvironmentObject var settings: SettingsViewModel
	@EnvironmentObject var viewRouter: ViewRouter

	var body: some View {
		Button {
			settings.showConnectInvite.toggle()
		} label: {
			Text("Non")
		}

		Button {
			viewRouter.currentPage = .welcome
		} label: {
			Text("Oui")
		}
	}
}
