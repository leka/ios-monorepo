//
//  BotConnectionIndicator.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 18/3/23.
//

import SwiftUI

struct BotConnectionIndicator: View {

	@EnvironmentObject var botVM: BotViewModel
	// Animation
	@State private var isAnimated: Bool = false
	@State private var diameter: CGFloat = 0

    var body: some View {
		ZStack {
			Circle()
				.fill(botVM.botIsConnected ? Color("lekaGreen") : Color("lekaDarkGray"))
				.opacity(0.4)

			Image(botVM.botIsConnected ? "bot_on" : "bot_off")
				.resizable()
				.renderingMode(.original)
				.aspectRatio(contentMode: .fit)
				.frame(width: 44, height: 44, alignment: .center)

			Circle()
				.stroke(botVM.botIsConnected ? Color("lekaGreen") : Color("lekaDarkGray"),
						lineWidth: 4)
				.frame(width: 44, height: 44)
		}
		.frame(width: 67, height: 67, alignment: .center)
		.background(
			Circle()
				.fill(Color("lekaGreen"))
				.frame(width: diameter, height: diameter)
				.opacity(isAnimated ? 0.0 : 0.8)
				.animation(Animation.easeInOut(duration: 1.5).delay(5).repeatForever(autoreverses: false), value: diameter)
				.opacity(botVM.botIsConnected ? 1 : 0.0)
		)
		.onAppear {
			isAnimated = true
			diameter = isAnimated ? 100 : 0
		}
    }
}
