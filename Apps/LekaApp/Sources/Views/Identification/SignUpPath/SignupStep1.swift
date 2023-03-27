//
//  SignupStep1.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 14/12/22.
//

import SwiftUI

struct SignupStep1: View {

	@EnvironmentObject var metrics: UIMetrics

	private let data: TileData = .signup_step1
	@State private var navigateToSignup1BLE: Bool = false

	var body: some View {
		ZStack {
			Color("lekaLightBlue").ignoresSafeArea()
			tile
		}
		.edgesIgnoringSafeArea(.top)
		.navigationDestination(isPresented: $navigateToSignup1BLE) {
			SignupStep1BLE()
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
					.frame(height: metrics.tilePictoHeight_small)
					.padding(.bottom, 30)

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
			.padding(metrics.tileContentPadding)
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
				navigateToSignup1BLE.toggle()
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
