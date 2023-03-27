//
//  BotBatteryIndicator.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 27/1/23.
//

import SwiftUI

struct BotBatteryIndicator: View {

	@Binding var level: Double
	@Binding var charging: Bool
	private let images: [String] = [
		"battery_25", "battery_25_2", "battery_50", "battery_75", "battery_100", "battery_50_bolt", "battery_100_bolt",
	]

	@State private var opacity: Double = 1
	private func imageGivenValue() -> String {
		if level < 25 {
			return charging ? "battery_50_bolt" : "battery_25_2"
		} else if 25..<50 ~= level {
			return charging ? "battery_50_bolt" : "battery_25"
		} else if 50..<75 ~= level {
			return charging ? "battery_50_bolt" : "battery_50"
		} else if 75..<100 ~= level {
			return charging ? "battery_50_bolt" : "battery_75"
		} else {
			return charging ? "battery_100_bolt" : "battery_100"
		}
	}

	var body: some View {
		Image(imageGivenValue())
			.resizable()
			.renderingMode(.original)
			.aspectRatio(contentMode: .fit)
			.frame(width: 24, height: 13)
			.padding([.vertical, .trailing], 5)
			.opacity(opacity)
			.animation(level < 25 ? .easeIn(duration: 1.0).repeatForever(autoreverses: false) : .easeIn, value: opacity)
			.animation(.easeIn(duration: 0.3), value: imageGivenValue())
			.onChange(
				of: level,
				perform: { value in
					if value < 25 {
						opacity = 0
					} else {
						opacity = 1
					}
				})
	}
}

struct BotBatteryIndicator_Previews: PreviewProvider {
	static var previews: some View {
		BotBatteryIndicator(level: .constant(98), charging: .constant(true))
	}
}
