// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - WelcomeViewDeprecated

struct WelcomeViewDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var viewRouter: ViewRouterDeprecated
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

                VStack(spacing: 30) {
                    self.logoLeka

                    NavigationLink("Créer un compte") {
                        SignupViewDeprecated()
                    }
                    .buttonStyle(Connect_ButtonStyle())

                    NavigationLink("Se connecter") {
                        LoginViewDeprecated()
                    }
                    .buttonStyle(Connect_ButtonStyle(reversed: true))
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    self.skipButton
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
                self.company.setupDiscoveryCompany()
                self.viewRouter.currentPage = .home
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

// MARK: - WelcomeViewDeprecated_Previews

struct WelcomeViewDeprecated_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeViewDeprecated()
            .environmentObject(CompanyViewModelDeprecated())
            .environmentObject(ViewRouterDeprecated())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
