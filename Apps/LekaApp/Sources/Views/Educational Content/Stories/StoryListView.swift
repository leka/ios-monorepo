//
//  StoryListView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 23/1/23.
//

import SwiftUI

struct StoryListView: View {

    @EnvironmentObject var settings: SettingsViewModel
	@EnvironmentObject var sidebar: SidebarViewModel

    private let images: [String] = ["story-1", "story-2", "story-3", "story-4", "story-5", "story-6"]

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()

            let columns = Array(repeating: GridItem(), count: 3)
            VStack {
                LazyVGrid(columns: columns) {
                    ForEach(images.indices, id: \.self) { item in
                        Image(images[item])
                            .ActivityIcon_ImageModifier(padding: 20)
                            .padding()
                    }
                }
                .safeAreaInset(edge: .top) {
                    if settings.companyIsConnected && !sidebar.showInfo() {
                        Color.clear
                            .frame(height: settings.companyIsConnected ? 40 : 0)
                    } else {
                        InfoTileManager()
                    }
                }
                Spacer()
            }
        }
        .animation(.easeOut(duration: 0.4), value: sidebar.showInfo())
        .onAppear { sidebar.sidebarVisibility = .all }
    }
}

struct StoryListView_Previews: PreviewProvider {
    static var previews: some View {
        StoryListView()
			.environmentObject(SidebarViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
    }
}
