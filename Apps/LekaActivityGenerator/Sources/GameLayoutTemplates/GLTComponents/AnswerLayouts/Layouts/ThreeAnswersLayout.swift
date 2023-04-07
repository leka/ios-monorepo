//
//  ThreeAnswersLayout.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 1/4/23.
//

import SwiftUI

struct ThreeAnswersLayout: View {

	@EnvironmentObject var defaults: GLT_Defaults

	var body: some View {
		Grid(horizontalSpacing: defaults.cellSpacing, verticalSpacing: defaults.cellSpacing) {
			GridRow {
				CircularAnswerButton(answer: 0)
				Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
				CircularAnswerButton(answer: 1)
			}
			GridRow {
				Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
				CircularAnswerButton(answer: 2)
				//					.gridCellColumns(3)
				Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
			}
		}
	}
}
