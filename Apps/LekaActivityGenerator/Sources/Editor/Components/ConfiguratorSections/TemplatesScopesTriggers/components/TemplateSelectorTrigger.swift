//
//  templateSelectorTrigger.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 4/4/23.
//

import SwiftUI

struct TemplateSelectorTrigger: View {

	//	@EnvironmentObject var configuration: GLT_Configurations

	var body: some View {
		NavigationLink(destination: TemplateSelector()) {
			Text("Ouvrir le sélecteur de Templates")
				.foregroundColor(Color("lekaSkyBlue"))
		}
		.padding(.leading, 30)
		.frame(minHeight: 35)
	}
}
