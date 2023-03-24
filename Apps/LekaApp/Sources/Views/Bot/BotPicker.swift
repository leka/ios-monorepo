//
//  BotsConnectView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 28/11/22.
//

import SwiftUI

struct BotPicker: View {

    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics
	@EnvironmentObject var botVM: BotViewModel

    @State private var searchBtnLabel: String = "Rechercher"
    @State private var allBots: Int = 0
	@State private var navigateToSignup1Final: Bool = false

        // TESTs ===========================================
    @State private var showNoBotTile: Bool = false
	func resetForTests() {
		botVM.botIsConnected = false
		botVM.currentlyConnectedBotIndex = nil
		botVM.currentlySelectedBotIndex = nil
	}
        // TESTs ===========================================

    var body: some View {
        ZStack(alignment: .center) {
            CloudsBGView()
                .onTapGesture {
                    botVM.currentlySelectedBotIndex = nil
                }

            VStack {
                Spacer()

				BotStore(botVM: botVM, allBots: $allBots, showNoBotTile: $showNoBotTile)
					.onAppear {
						allBots = 13 // For the tests
					}

                HStack(spacing: 60) {
                    Spacer()
                    searchButton
                    connectionButton
                    Spacer()
                }
                .padding(.vertical, 20)

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
		.navigationDestination(isPresented: $navigateToSignup1Final) {
			SignupStep1Final()
		}
        .toolbar {
            ToolbarItem(placement: .principal) { navigationTitle }
            if viewRouter.currentPage == .bots {
                ToolbarItem(placement: .navigationBarLeading) { backButton }
            } else {
                ToolbarItem(placement: .navigationBarTrailing) { continueButton }
            }
        }
    }

	private var searchButton: some View {
		Button(action: {
// TESTs ===========================================
			searchBtnLabel = "Recherche en cours..."
			resetForTests()
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
				if allBots == 0 {
					if viewRouter.currentPage == .welcome {
						if showNoBotTile {
							allBots += 1
						}
						showNoBotTile.toggle()
					} else {
						allBots += 1
					}
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						searchBtnLabel = "Rechercher"
					}
				} else if allBots < 3 {
					allBots += 1
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						searchBtnLabel = "Rechercher"
					}
				} else if allBots == 3 {
					allBots = 13
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						searchBtnLabel = "Rechercher"
					}
				} else {
					allBots = 0
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						searchBtnLabel = "Rechercher"
					}
				}
			}
// TESTs ===========================================
		}, label: {
			Text(searchBtnLabel)
				.font(metrics.bold15)
				.padding(6)
				.frame(width: 210)
		})
		.buttonStyle(.borderedProminent)
		.tint(Color("lekaSkyBlue"))
		.disabled(searchBtnLabel == "Recherche en cours...")

	}

	private var connectionButton: some View {
		Button(action: {
			if botVM.currentlyConnectedBotIndex == botVM.currentlySelectedBotIndex {
				botVM.currentlyConnectedBotIndex = nil
				botVM.currentlyConnectedBotName = ""
				botVM.botIsConnected = false
			} else {
				botVM.currentlyConnectedBotIndex = botVM.currentlySelectedBotIndex
				botVM.currentlyConnectedBotName = "LKAL \(String(describing: botVM.currentlyConnectedBotIndex))"
				botVM.botIsConnected = true
			}
		}, label: {
			Group {
				if botVM.currentlyConnectedBotIndex == botVM.currentlySelectedBotIndex {
					Text("Se déconnecter")
				} else {
					Text("Se connecter")
				}
			}
			.font(metrics.bold15)
			.padding(6)
			.frame(width: 210)

		})
		.buttonStyle(.borderedProminent)
		.tint(botVM.currentlyConnectedBotIndex == botVM.currentlySelectedBotIndex ? Color("lekaOrange") : .accentColor)
		.disabled(allBots == 0)
		.disabled(botVM.currentlySelectedBotIndex == nil) // For the tests
	}

	// Toolbar
	private var navigationTitle: some View {
		HStack(spacing: 4) {
			Text("Connectez-vous à votre robot")
			if settings.companyIsConnected && settings.exploratoryModeIsOn {
				Image(systemName: "binoculars.fill")
			}
		}
		.font(metrics.semi17)
		.foregroundColor(.accentColor)
	}

	private var backButton: some View {
		Button(action: {
			viewRouter.currentPage = .home
		}) {
			HStack(spacing: 4) {
				Image(systemName: "chevron.left")
				Text("Retour")
			}
		}
		.tint(.accentColor)
	}

	private var continueButton: some View {
//		NavigationLink(value: IdentificationNavDestinations.signup1Final) {
//			HStack(spacing: 4) {
//				Text("Continuer")
//				Image(systemName: "chevron.right")
//			}
//		}
		Button(action: {
			navigateToSignup1Final.toggle()
		}, label: {
			HStack(spacing: 4) {
				Text("Continuer")
				Image(systemName: "chevron.right")
			}
		})
		.tint(.accentColor)
	}
}

struct BotsConnectView_Previews: PreviewProvider {
    static var previews: some View {
        BotPicker()
			.environmentObject(BotViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
            .environmentObject(ViewRouter())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
