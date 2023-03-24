//
//  SignupStep2.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 14/12/22.
//

import SwiftUI

struct SignupStep2: View {

    @EnvironmentObject var metrics: UIMetrics

	private let data: TileData = .signup_step2
	@State private var navigateToTeacherCreation: Bool = false

	var body: some View {
		ZStack {
			Color("lekaLightBlue").ignoresSafeArea()
			tile
		}
		.edgesIgnoringSafeArea(.top)
		.navigationDestination(isPresented: $navigateToTeacherCreation) {
			CreateTeacherProfileView()
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
					.frame(height: metrics.tilePictoHeight_medium)
					.padding(.top, 20)
				Spacer()
				// Title
				Text(data.content.title!)
					.font(metrics.semi17)
					.foregroundColor(Color("lekaOrange"))
					.padding(.vertical, 20)
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
			navigateToTeacherCreation.toggle()
		}, label: {
			Text(data.content.CTALabel!)
		})
		.buttonStyle(
			BorderedCapsule_NoFeedback_ButtonStyle(
				font: metrics.reg17,
				color: .accentColor,
				width: metrics.tileBtnWidth)
		)
	}
}
