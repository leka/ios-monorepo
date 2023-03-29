//
//  AvatarPickerTriggersComponentViews.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 15/3/23.
//

import SwiftUI

struct AvatarTriggerImageView: View {

	var img: String

	var body: some View {
		ZStack {
			Circle()
				.fill(.white)
				.shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
			Group {
				Image(img)
					.resizable()
					.foregroundColor(.accentColor)
					.aspectRatio(contentMode: .fit)
					.clipShape(Circle())
					.padding(10)
			}
			.shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
			Circle()
				.inset(by: 10)
				.strokeBorder(Color.accentColor, lineWidth: 4, antialiased: true)
		}
		.frame(width: 170, height: 170)
	}
}

struct AvatarTriggerCTAView: View {

	@EnvironmentObject var metrics: UIMetrics

	var body: some View {
		Text("choisir un avatar")
			.font(metrics.reg17)
			.foregroundColor(Color.accentColor)
			.padding(.vertical, 4)
			.padding(.horizontal, 20)
			.overlay(
				Capsule()
					.stroke(Color.accentColor, lineWidth: 1)
			)
			.background(.white, in: Capsule())
			.padding(10)
	}
}
