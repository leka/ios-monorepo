//
//  CircularPreviewAnswerContent.swift
//  LekaActivityGenerator
//
//  Created by Mathieu Jeannot on 10/4/23.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct CircularPreviewAnswerContent: View {

	@EnvironmentObject var gameEngine: GameEngine

	var content: String
	@State private var size: CGFloat = 50

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
	}
}
