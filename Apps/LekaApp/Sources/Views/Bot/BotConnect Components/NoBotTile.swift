//
//  NoBotTile.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 21/3/23.
//

import SwiftUI

struct NoBotTile: View {

	@EnvironmentObject var metrics: UIMetrics

	@State private var navigateToSignup2: Bool = false

    var body: some View {
		HStack(alignment: .center, spacing: 0) {
			VStack(spacing: 0) {
				// Picto
				Image(TileData.noBot.content.image!)
					.resizable()
					.renderingMode(.original)
					.aspectRatio(contentMode: .fit)
					.frame(height: metrics.tilePictoHeight_small)
				Spacer()
				// Message
				Text(TileData.noBot.content.message!)
					.font(metrics.reg17)
				Spacer()
				// CTA Button
				accessoryView
			}
			.multilineTextAlignment(.center)
			.foregroundColor(.accentColor)
			.frame(width: metrics.tileContentWidth)
			.padding(metrics.tileContentPadding)
		}
		.frame(width: metrics.tileSize.width,
			   height: metrics.tileSize.height)
		.navigationDestination(isPresented: $navigateToSignup2) {
			SignupStep2()
		}
		.background(Color("lekaLightGray"),
					in: RoundedRectangle(cornerRadius: metrics.tilesRadius, style: .continuous))
    }

	private var accessoryView: some View {
		Button(action: {
			navigateToSignup2.toggle()
		}, label: {
			Text(TileData.noBot.content.CTALabel!)
		})
		.buttonStyle(
			BorderedCapsule_NoFeedback_ButtonStyle(
				font: metrics.reg17,
				color: .accentColor,
				width: metrics.tileBtnWidth)
		)
	}
}
