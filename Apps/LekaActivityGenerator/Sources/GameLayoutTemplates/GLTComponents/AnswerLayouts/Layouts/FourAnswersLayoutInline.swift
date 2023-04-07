//
//  FourAnswersLayoutInline.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 1/4/23.
//

import SwiftUI

struct FourAnswersLayoutInline: View {

	@EnvironmentObject var defaults: GLT_Defaults

	var body: some View {
		HStack(spacing: defaults.cellSpacing) {
			ForEach(0..<4) { answer in
				CircularAnswerButton(answer: answer)
			}
		}
	}
}
