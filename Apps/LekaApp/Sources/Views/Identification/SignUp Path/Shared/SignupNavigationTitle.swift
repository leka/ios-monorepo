//
//  SignupNavigationTitle.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 17/3/23.
//

import SwiftUI

struct SignupNavigationTitle: View {
	
	@EnvironmentObject var metrics: UIMetrics
	
    var body: some View {
		Text("Première connexion")
			.font(metrics.semi17)
			.foregroundColor(.accentColor)
    }
}
