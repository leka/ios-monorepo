//
//  ContentView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 31/10/22.
//

import SwiftUI

struct HomeView: View {

	@EnvironmentObject var botVM: BotViewModel
	@EnvironmentObject var sidebar: SidebarViewModel
	@EnvironmentObject var settings: SettingsViewModel
	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var metrics: UIMetrics

	// delete
	//    private func changeBatteryLevel() {
	//        if botVM.botIsCharging {
	//            if botVM.botChargeLevel == 100 {
	//                botVM.botIsCharging.toggle() // off
	//            } else {
	//                botVM.botChargeLevel += 50
	//            }
	//        } else {
	//            if botVM.botChargeLevel == 0 {
	//				botVM.botIsCharging.toggle() // on
	//				botVM.botChargeLevel += 50
	//            } else {
	//                botVM.botChargeLevel -= 25
	//            }
	//        }
	//    }

	// Toolbar Items - send those within their views directly, same for the infoButtons
	private var toolbarTitle: some View {
		HStack(spacing: 4) {
			Text(sidebar.setNavTitle())
			if settings.companyIsConnected && settings.exploratoryModeIsOn {
				Image(systemName: "binoculars.fill")
			}
		}
		.font(metrics.semi17)
		.foregroundColor(.accentColor)
	}

	private var infoButton: some View {
		Button {
			sidebar.updateShowInfo()
		} label: {
			Image(systemName: "info.circle")
				.foregroundColor(.accentColor)
		}
		.opacity(sidebar.showInfo() ? 0 : 1)
	}

	@ViewBuilder
	private func contentView(_ current: SidebarDestinations) -> some View {
		if current == .teachers {
			FollowUpList_Teachers()
		} else {
			FollowUpList_Users()
		}
	}

	var body: some View {
		Group {
			if sidebar.has3Columns {
				// Follow Up
				NavigationSplitView(columnVisibility: $sidebar.contentVisibility) {
					SidebarView()
				} content: {
					contentView(sidebar.currentView)
				} detail: {
					sidebar.allSidebarDestinationViews
						//                        .blur(radius: sidebar.contentVisibility == .all ? 10 : 0)
						//                        .overlay(
						//                            Color.accentColor
						//                                .edgesIgnoringSafeArea(.all)
						//                                .opacity(sidebar.contentVisibility == .all ? 0.1 : 0)
						//                                .onTapGesture {
						//                                    withAnimation(.easeIn) {
						//										sidebar.contentVisibility = .doubleColumn
						//                                    }
						//                                }
						//                        )
						.navigationBarTitleDisplayMode(.inline)
						.onAppear {
							sidebar.contentVisibility = NavigationSplitViewVisibility.all
						}
						.toolbar {
							ToolbarItem(placement: .principal) {
								toolbarTitle
							}
							ToolbarItem(placement: .navigationBarTrailing) {
								infoButton
							}
							//                            ToolbarItem(placement: .navigationBarLeading) {
							//                                Button {
							//									sidebar.contentVisibility = sidebar.contentVisibility == .detailOnly ? .doubleColumn : .detailOnly
							//                                } label: {
							//                                    Image(systemName: "arrow.up.backward.and.arrow.down.forward")
							//                                        .foregroundColor(.accentColor)
							//                                }
							//                                .opacity(sidebar.contentVisibility == .detailOnly ? 0 : 1)
							//                            }
						}
						.background(Color("lekaLightBlue").ignoresSafeArea())
				}
				.navigationSplitViewStyle(.prominentDetail)
			} else {
				// Educ Content & Settings
				NavigationSplitView(columnVisibility: $sidebar.sidebarVisibility) {
					SidebarView()
				} detail: {
					NavigationStack {
						sidebar.allSidebarDestinationViews
							.navigationBarTitleDisplayMode(.inline)
							.toolbar {
								ToolbarItem(placement: .principal) {
									toolbarTitle
								}

								//                                ToolbarItem(placement: .navigationBarLeading) {
								//                                    Button(action: { changeBatteryLevel() }, label: {
								//                                        Text("Batterie")
								//                                    })
								//                                }

								ToolbarItem(placement: .navigationBarTrailing) {
									infoButton
								}
							}
							.background(Color("lekaLightBlue").ignoresSafeArea())
					}
				}
			}
		}
		.preferredColorScheme(.light)
		.sheet(isPresented: $sidebar.showSettings) {
			SettingsView()
		}
		.alert("Voulez-vous quitter le mode exploratoire ?", isPresented: $settings.showSwitchOffExploratoryAlert) {
			Button(role: .destructive) {
				settings.exploratoryModeIsOn.toggle()
			} label: {
				Text("Quitter")
			}
		} message: {
			Text(
				"Vous êtes actuellement en mode exploratoire. Ce mode vous permet d'explorer les contenus éducatifs sans que l'utilisation ne soit enregistrée."
			)
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
			.environmentObject(SidebarViewModel())
			.environmentObject(CompanyViewModel())
			.environmentObject(SettingsViewModel())
			.environmentObject(UIMetrics())
			.environmentObject(ViewRouter())
			.environmentObject(CurriculumViewModel())
			.environmentObject(ActivityViewModel())
			.environmentObject(BotViewModel())
			.previewInterfaceOrientation(.landscapeLeft)
	}
}
