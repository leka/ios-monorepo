//
//  InstructionsEditorTrigger.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 2/4/23.
//

import SwiftUI

struct InstructionsEditorTrigger: View {

	@Binding var language: Languages

	var body: some View {
		Section {
			NavigationLink(destination: InstructionsEditor(language: $language)) {
				Text("Ouvrir l'éditeur de consigne")
					.foregroundColor(Color("lekaSkyBlue"))
			}
			.frame(minHeight: 50)
			.padding(.leading, 30)
		} header: {
			Text("Consigne")
				.foregroundColor(.accentColor)
				.headerProminence(.increased)
		}
	}
}
