//
//  SettingsViewModel.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 12/1/23.
//

import Foundation

class SettingsViewModel: ObservableObject {

	// Connexion-related properties - Settings
	@Published var companyIsLoggingIn: Bool = false
	@Published var companyIsConnected: Bool = false
	@Published var exploratoryModeIsOn: Bool = false
	@Published var showSwitchOffExploratoryAlert: Bool = false

	@Published var showConfirmDisconnection: Bool = false
	@Published var showConfirmDeleteAccount: Bool = false

	// This will go later in UIEvents Environment
	@Published var showConnectInvite: Bool = false

}
