//
//  SidebarView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 2/11/22.
//

import SwiftUI

struct SidebarView: View {

    @EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    @State private var appVersion: String? = ""
    @State private var buildNumber: String? = ""

    var body: some View {
        ScrollView {
            VStack {
                SidebarHeaderView()
                SidebarSections()
                Spacer()
                VStack(spacing: 20) {
                    Spacer()
                    settingsButton
                    appVersionIndicator
                }
                .padding(.bottom, 20)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(Color("lekaLightGray"))
        .task {
            appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        }
    }

    @ViewBuilder
    private var settingsButton: some View {
        if settings.companyIsConnected {
            Button {
                sidebar.showSettings.toggle()
            } label: {
                HStack {
                    Image(systemName: "gear")
                    Text("Réglages")
                        .font(metrics.reg17)
                }
                .foregroundColor(Color("darkGray"))
                .frame(width: 200, height: 44)
                .background(.white, in: RoundedRectangle(cornerRadius: metrics.btnRadius, style: .continuous))
                .contentShape(Rectangle())
            }
        } else {
            EmptyView()
        }
    }

    private var appVersionIndicator: some View {
        Text("My Leka App - Version \(appVersion!) (\(buildNumber!))")
            .foregroundColor(Color("darkGray"))
            .font(metrics.reg12)
            .frame(alignment: .bottom)
    }

}
