//
//  SignupFinalStep.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 14/12/22.
//

import SwiftUI

struct SignupFinalStep: View {
    
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var viewRouter: ViewRouter
    
	private let data: TileData = .signup_finalStep
    
    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()
			tile
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar {
            ToolbarItem(placement: .principal) {
				SignupNavigationTitle()
            }
        }
    }
	
	private var tile: some View {
		HStack(alignment: .center, spacing: 0) {
			VStack(spacing: 0) {
				// Title
				Text(data.content.title!)
					.font(metrics.semi17)
					.foregroundColor(Color("lekaOrange"))
				Spacer()
				// Message
				VStack(spacing: 10) {
					Text(data.content.message!)
						.padding(.bottom, 10)
					VStack(alignment: .leading, spacing: 8) {
						Text("✅ Vous connecter au robot")
						Text("✅ Créer votre profil de professionnel")
						Text("✅ Créer votre 1er profil de personne accompagnée")
						Text("Vous allez maintenant pouvoir découvrir l'univers Leka et le contenu éducatif.")
							.padding(.vertical, 10)
					}
				}
				.multilineTextAlignment(.center)
				.font(metrics.reg17)
				Spacer()
				// CTA Button
				accessoryView
			}
			.multilineTextAlignment(.center)
			.foregroundColor(.accentColor)
			.frame(width: 400)
			.padding(metrics.tileContentPadding)
		}
		.frame(width: metrics.tileSize.width,
			   height: metrics.tileSize.height)
		.background(.white,
					in: RoundedRectangle(cornerRadius: metrics.tilesRadius, style: .continuous))
	}
	
	private var accessoryView: some View {
		Button {
			withAnimation {
				viewRouter.currentPage = .home
			}
		} label: {
			Text(data.content.CTALabel!)
		}
		.buttonStyle(
			BorderedCapsule_NoFeedback_ButtonStyle(
				font: metrics.reg17,
				color: Color.accentColor)
		)
	}
}
