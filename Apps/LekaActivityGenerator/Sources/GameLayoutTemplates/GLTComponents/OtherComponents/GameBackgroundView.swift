//
//  GLT_BackgroundView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/3/23.
//

import SwiftUI

struct GameBackgroundView: View {

	@EnvironmentObject var defaults: GLT_Defaults

	var body: some View {
		defaults.activitiesBackgroundColor.edgesIgnoringSafeArea(.all)
	}
}
