import SwiftUI

struct TwoAnswersLayout: View {

	@EnvironmentObject var defaults: GLT_Defaults

	var body: some View {
		HStack(spacing: defaults.horizontalCellSpacing) {
			ForEach(0..<2) { answer in
				CircularAnswerButton(answer: answer)
			}
		}
	}
}
