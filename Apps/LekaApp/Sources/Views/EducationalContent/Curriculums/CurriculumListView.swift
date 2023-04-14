// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct CurriculumListView: View {

    @EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var curriculumVM: CurriculumViewModel

    private let columns = Array(repeating: GridItem(), count: 3)

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()

            ScrollView {
                LazyVGrid(columns: columns) {
                    allCurriculums
                }
            }
            .safeAreaInset(edge: .top) {
                InfoTileManager()
            }
        }
        .animation(.easeOut(duration: 0.4), value: sidebar.showInfo())
    }

    private var allCurriculums: some View {
        ForEach(curriculumVM.availableCurriculums.enumerated().map({ $0 }), id: \.element.id) { index, item in
            Button {
                curriculumVM.selectedCurriculum = index
                viewRouter.currentPage = .curriculumDetail
            } label: {
                CurriculumPillShapedView(
                    curriculum: item,  // Integrate rank and icon within curriculum Type, delete following properties
                    icon: curriculumVM.setCurriculumIcon(for: item),
                    rank: "\(index+1)/\(curriculumVM.availableCurriculums.count)")
            }
            .padding()
        }
    }
}

struct CurriculumListView_Previews: PreviewProvider {
    static var previews: some View {
        CurriculumListView()
            .environmentObject(SidebarViewModel())
            .environmentObject(CurriculumViewModel())
            .environmentObject(UIMetrics())
            .environmentObject(ViewRouter())
            .environmentObject(SettingsViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
