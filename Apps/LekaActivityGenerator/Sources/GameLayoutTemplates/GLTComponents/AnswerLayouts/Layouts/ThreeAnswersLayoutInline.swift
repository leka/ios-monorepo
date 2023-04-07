//
//  SwiftUIView.swift
//
//
//  Created by Mathieu Jeannot on 31/3/23.
//

import SwiftUI

struct ThreeAnswersLayoutInline: View {

	@EnvironmentObject var defaults: GLT_Defaults

	var body: some View {
		HStack(spacing: defaults.cellSpacing) {
			ForEach(0..<3) { answer in
				CircularAnswerButton(answer: answer)
			}
		}
	}
}
