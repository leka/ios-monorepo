//
//  CircularAnswerContent.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 3/4/23.
//

import SwiftUI

struct CircularAnswerContent: View {

	@EnvironmentObject var gameEngine: GameEngine
	@EnvironmentObject var defaults: GLT_Defaults

	var content: String
	@State var size: CGFloat = .zero

	var body: some View {
		Group {
			if gameEngine.answersAreImages {
				Image(content)
					.resizable()
					.aspectRatio(contentMode: .fit)
			} else {
				Circle()
					.fill(gameEngine.stringToColor(from: content))
			}
		}
		.clipShape(Circle().inset(by: 2))
		.frame(width: size, height: size, alignment: .center)
		.onAppear {
			guard size != .zero else {
				size = defaults.playGridBtnSize
				return
			}
		}
	}
}
