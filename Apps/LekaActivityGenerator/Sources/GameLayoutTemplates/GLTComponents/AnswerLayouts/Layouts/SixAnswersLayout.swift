//
//  SixAnswersLayout.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 1/4/23.
//

import SwiftUI

struct SixAnswersLayout: View {

	@EnvironmentObject var defaults: GLT_Defaults

	var body: some View {
		Grid(horizontalSpacing: defaults.cellSpacing, verticalSpacing: defaults.cellSpacing) {
			GridRow {
				ForEach(0..<3) { answer in
					CircularAnswerButton(answer: answer)
				}
			}
			GridRow {
				ForEach(3..<6) { answer in
					CircularAnswerButton(answer: answer)
				}
			}
		}
	}
}
