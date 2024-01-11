// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SidebarView: View {
    // MARK: Internal

    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ScrollView {
            VStack {
                SidebarHeaderView()
                SidebarSections()
                Spacer()
                VStack(spacing: 20) {
                    Spacer()
                    self.settingsButton
                    self.appVersionIndicator
                }
                .padding(.bottom, 20)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(DesignKitAsset.Colors.lekaLightGray.swiftUIColor)
        .task {
            self.appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            self.buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        }
    }

    // MARK: Private

    @State private var appVersion: String? = ""
    @State private var buildNumber: String? = ""

    @ViewBuilder
    private var settingsButton: some View {
        if self.settings.companyIsConnected {
            Button {
                self.navigationVM.showSettings.toggle()
            } label: {
                HStack {
                    Image(systemName: "gear")
                    Text("Réglages")
                        // TODO: (@ui/ux) - Design System - replace with Leka font
                        .font(.body)
                }
                .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
                .frame(width: 200, height: 44)
                .background(.white, in: RoundedRectangle(cornerRadius: self.metrics.btnRadius, style: .continuous))
                .contentShape(Rectangle())
            }
        } else {
            EmptyView()
        }
    }

    private var appVersionIndicator: some View {
        Text("My Leka App - Version \(self.appVersion!) (\(self.buildNumber!))")
            .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
            // TODO: (@ui/ux) - Design System - replace with Leka font
            .font(.caption2)
            .frame(alignment: .bottom)
    }
}
