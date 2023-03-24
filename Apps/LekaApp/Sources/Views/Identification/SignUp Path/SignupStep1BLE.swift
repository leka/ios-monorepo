//
//  SignupStep1BLE.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 17/12/22.
//

import SwiftUI

struct SignupStep1BLE: View {

    @EnvironmentObject var metrics: UIMetrics

	private let data: TileData = .signup_step1_ble
	@State private var navigateToBotPicker: Bool = false

    var body: some View {
		ZStack {
			Color("lekaLightBlue").ignoresSafeArea()
			tile
		}
		.edgesIgnoringSafeArea(.top)
		.navigationDestination(isPresented: $navigateToBotPicker) {
			BotPicker()
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
		.frame(width: metrics.tileSize.width,
			   height: metrics.tileSize.height)
		.background(.white,
					in: RoundedRectangle(cornerRadius: metrics.tilesRadius, style: .continuous))
	}

	private var accessoryView: some View {
		Button(action: {
			navigateToBotPicker.toggle()
		}, label: {
			HStack(spacing: 10) {
				Image(data.content.pictoCTA!)
				Text(data.content.CTALabel!)
			}
		})
		.buttonStyle(
			BorderedCapsule_NoFeedback_ButtonStyle(
				font: metrics.reg17,
				color: .accentColor,
				width: metrics.tileBtnWidth)
		)
	}
}
