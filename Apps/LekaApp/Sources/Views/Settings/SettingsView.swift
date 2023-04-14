// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color("lekaLightGray").ignoresSafeArea()

                Form {
                    Group {
                        SettingsSection_Credentials()
                        SettingsSection_Exploratory()
                        SettingsSection_Profiles()
                        SettingsSection_Account()
                    }
                    .padding(.horizontal, 20)
                }
                .scrollDisabled(true)
                .padding(.horizontal, 10)
                .formStyle(.grouped)
                .foregroundColor(.accentColor)
                .font(metrics.reg17)
            }
            .interactiveDismissDisabled()
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.accentColor, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 4) {
                        Text("Réglages")
                        if settings.companyIsConnected && settings.exploratoryModeIsOn {
                            Image(systemName: "binoculars.fill")
                        }
                    }
                    .font(metrics.semi17)
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        },
                        label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Fermer")
                            }
                            .foregroundColor(.white)
                        })
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {

    @State static var open: Bool = true

    static var previews: some View {
        Color("lekaLightBlue")
            .ignoresSafeArea()
            .sheet(isPresented: $open) {
                SettingsView()
                    .environmentObject(SidebarViewModel())
                    .environmentObject(SettingsViewModel())
                    .environmentObject(CompanyViewModel())
                    .environmentObject(ViewRouter())
                    .environmentObject(UIMetrics())
            }
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
