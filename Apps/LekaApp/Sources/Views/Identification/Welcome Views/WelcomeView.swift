//
//  LoginView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/11/22.
//

import SwiftUI


struct WelcomeView: View {
	
	@EnvironmentObject var company: CompanyViewModel
	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var metrics:  UIMetrics
	
	var body: some View {
		NavigationStack {
			ZStack(alignment: .center) {
				Color("lekaLightBlue").ignoresSafeArea()
				
				VStack(spacing: 30) {
					logoLeka
					
					NavigationLink("Créer un compte") {
						SignupView()
					}
					.buttonStyle(Connect_ButtonStyle())
					
					NavigationLink("Se connecter") {
						LoginView()
					}
					.buttonStyle(Connect_ButtonStyle(reversed: true))
				}
			}
			.edgesIgnoringSafeArea(.top)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					skipButton
				}
			}
		}
	}
	
	private var logoLeka: some View {
		Image("lekaLogo_AFH")
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(height: 90)
			.padding(.bottom, 30)
	}
	
	private var skipButton: some View {
		Button(action: {
			company.setupDiscoveryCompany()
			viewRouter.currentPage = .home
		}) {
			HStack(spacing: 4) {
				Text("Passer cette étape")
				Image(systemName: "chevron.right")
			}
		}
	}
}


struct WelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeView()
			.environmentObject(CompanyViewModel())
		//            .environmentObject(SettingsViewModel())
			.environmentObject(ViewRouter())
			.environmentObject(UIMetrics())
			.previewInterfaceOrientation(.landscapeLeft)
	}
}
