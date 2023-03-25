//
//  CloudsBGView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 14/11/22.
//

import SwiftUI

struct CloudsBGView: View {
	var body: some View {
		Image("interface_cloud")
			.resizable()
			.renderingMode(.original)
			.aspectRatio(contentMode: .fill)
			.edgesIgnoringSafeArea(.all)
	}
}

struct CloudsBGView_Previews: PreviewProvider {
	static var previews: some View {
		CloudsBGView()
	}
}
