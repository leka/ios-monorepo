//
//  ProfileSelector_Users.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 15/3/23.
//

import SwiftUI

struct ProfileSelector_Users: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()

            ProfileSet_Users()
                .padding(.top, 60)
        }
        .navigationDestination(
            isPresented: $viewRouter.goToGameFromCurriculums,
            destination: {
                GameView()
            }
        )
        .navigationDestination(
            isPresented: $viewRouter.goToGameFromActivities,
            destination: {
                GameView()
            }
        )
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 4) {
                    if settings.companyIsConnected && settings.exploratoryModeIsOn {
                        Image(systemName: "binoculars.fill")
                    }
                    Text("Choisir ou créer de nouveaux profils")
                }
                .font(metrics.semi17)
                .foregroundColor(.accentColor)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        if viewRouter.currentPage == .game {
                            viewRouter.currentPage = .home
                            viewRouter.goToGameFromActivities = false
                        } else {
                            dismiss()
                            viewRouter.goToGameFromCurriculums = false
                        }
                        viewRouter.showUserSelector = false
                    },
                    label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Retour")
                        }
                    })
            }
        }
    }
}
