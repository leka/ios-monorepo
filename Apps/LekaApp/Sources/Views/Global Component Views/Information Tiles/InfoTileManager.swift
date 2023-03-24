//
//  TileManager.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 23/1/23.
//

import SwiftUI

struct InfoTileManager: View {

	@EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        Group {
            if !settings.companyIsConnected {
                HStack(spacing: 15) {
                    InfoTile(data: .discovery)
                    InfoTile(data: sidebar.contextualInfo())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            } else if sidebar.showInfo() {
                InfoTile(data: sidebar.contextualInfo())
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            } else {
                EmptyView()
            }
        }
        .animation(.easeOut(duration: 0.4), value: sidebar.showInfo())
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}
