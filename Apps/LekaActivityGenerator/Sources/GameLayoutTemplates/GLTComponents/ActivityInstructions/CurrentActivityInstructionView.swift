//
//  CurrentActivityInstructionView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/3/23.
//

import SwiftUI

struct CurrentActivityInstructionView: View {

	@EnvironmentObject var gameEngine: GameEngine
	@EnvironmentObject var defaults: GLT_Defaults
	@Environment(\.dismiss) var dismiss

	@State private var instruction: String = ""

	var body: some View {
		NavigationStack {
			ZStack(alignment: .top) {
				// Header color
				Color.accentColor.ignoresSafeArea()

				// Background Color
				Color("lekaLightGray").padding(.top, 70)

				VStack(spacing: 0) {
					activityDetailHeader
					InstructionView(text: $instruction)
						.onAppear {
							instruction = gameEngine.currentActivity.instructions.localized()
						}
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbarBackground(.hidden, for: .navigationBar)
			.interactiveDismissDisabled()
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) { resumeButton }
			}
		}
		.preferredColorScheme(.light)
	}

	private var activityDetailHeader: some View {
		HStack {
			Spacer()
			Text(gameEngine.currentActivity.title.localized())
				.font(defaults.semi17)
				.foregroundColor(.white)
				.multilineTextAlignment(.center)
			Spacer()
		}
		.frame(height: 70)
		.padding(.horizontal, 20)
	}

	private var resumeButton: some View {
		Button(action: {
			dismiss()
		}) {
			Image(systemName: "multiply")
				.font(defaults.semi20)
				.foregroundColor(.white)
		}
	}
}
