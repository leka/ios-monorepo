// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - WelcomeView

struct WelcomeView: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

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

    // MARK: Private

    private var logoLeka: some View {
        Image(
            DesignKitAsset.Assets.lekaLogo.name,
            bundle: Bundle(for: DesignKitResources.self)
        )
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 90)
        .padding(.bottom, 30)
    }

    private var skipButton: some View {
        Button(
            action: {
                company.setupDiscoveryCompany()
                viewRouter.currentPage = .home
            },
            label: {
                HStack(spacing: 4) {
                    Text("Passer cette étape")
                    Image(systemName: "chevron.right")
                }
            }
        )
    }
}

// MARK: - WelcomeView_Previews

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(CompanyViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
