//
//  FourAnswersLayout.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 1/4/23.
//

import SwiftUI

struct FourAnswersLayout: View {

	@EnvironmentObject var defaults: GLT_Defaults

	var body: some View {
		Grid(horizontalSpacing: defaults.cellSpacing, verticalSpacing: defaults.cellSpacing) {
			GridRow {
				CircularAnswerButton(answer: 0)
				CircularAnswerButton(answer: 1)
			}
			GridRow {
				CircularAnswerButton(answer: 2)
				CircularAnswerButton(answer: 3)
			}
		}
	}
}
