//
//  SignupStep1Final.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 15/12/22.
//

import SwiftUI

struct SignupStep1Final: View {

	@EnvironmentObject var metrics: UIMetrics

	private let data: TileData = .signup_step1_Final
	@State private var navigateToSignup2: Bool = false

	var body: some View {
		ZStack {
			Color("lekaLightBlue").ignoresSafeArea()
			tile
		}
		.edgesIgnoringSafeArea(.top)
		.navigationDestination(isPresented: $navigateToSignup2) {
			SignupStep2()
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				SignupNavigationTitle()
			}
		}
	}

	private var tile: some View {
		HStack(alignment: .center, spacing: 0) {
			VStack(spacing: 0) {
				// Picto
				Image(data.content.image!)
					.resizable()
					.renderingMode(.original)
					.aspectRatio(contentMode: .fit)
					.frame(height: metrics.tilePictoHeight_big)
					.padding(.top, 20)
					.padding(.bottom, 10)

				// Title
				Text(data.content.title!)
					.font(metrics.semi17)
					.foregroundColor(Color("lekaOrange"))
				Spacer()
				// Message
				Text(data.content.message!)
					.font(metrics.reg17)
				Spacer()
				// CTA Button
				accessoryView
			}
			.multilineTextAlignment(.center)
			.foregroundColor(.accentColor)
			.frame(width: metrics.tileContentWidth)
			.padding(.bottom, metrics.tileContentPadding)
		}
		.frame(
			width: metrics.tileSize.width,
			height: metrics.tileSize.height
		)
		.background(
			.white,
			in: RoundedRectangle(cornerRadius: metrics.tilesRadius, style: .continuous))
	}

	private var accessoryView: some View {
		Button(
			action: {
				navigateToSignup2.toggle()
			},
			label: {
				Text(data.content.CTALabel!)
			}
		)
		.buttonStyle(
			BorderedCapsule_NoFeedback_ButtonStyle(
				font: metrics.reg17,
				color: .accentColor,
				width: metrics.tileBtnWidth)
		)
	}
}
