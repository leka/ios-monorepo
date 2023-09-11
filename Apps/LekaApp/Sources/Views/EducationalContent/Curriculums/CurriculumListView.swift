// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct CurriculumListView: View {

    @EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var curriculumVM: CurriculumViewModel
    @EnvironmentObject var metrics: UIMetrics

    private let columns = Array(repeating: GridItem(), count: 3)

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(CurriculumCategories.allCases, id: \.self) { category in
                            Section {
                                allCurriculums(category: category)
                            } header: {
                                headerViews(title: curriculumVM.getCurriculumList(category: category).sectionTitle)
                            }
                        }
                    }
                }
                .animation(.easeOut(duration: 0.4), value: sidebar.showInfo())
                .safeAreaInset(edge: .top) {
                    InfoTileManager()
                }
                .onAppear {
                    withAnimation { proxy.scrollTo(curriculumVM.currentCurriculumCategory, anchor: .top) }
                }
            }
        }
    }

    @ViewBuilder
    private func allCurriculums(category: CurriculumCategories) -> some View {
        let list: [Curriculum] = curriculumVM.getCurriculumsFrom(category: category)
        ForEach(list.enumerated().map({ $0 }), id: \.element.id) { index, item in
            Button {
                curriculumVM.currentCurriculumCategory = category
                curriculumVM.populateCurriculumList(category: category)
                curriculumVM.selectedCurriculum = index

            } label: {
                CurriculumPillShapedView(
                    curriculum: item,  // Integrate rank and icon within curriculum Type, delete following properties
                    icon: curriculumVM.setCurriculumIcon(for: item))
            }
            .padding()
        }
    }

    private func headerViews(title: LocalizedContent) -> some View {
        HStack {
            Text(title.localized())
                .font(metrics.semi17)
                .padding(16)
                .foregroundColor(.accentColor)
                .padding(.leading, 20)
            Spacer()
        }
    }
}

struct CurriculumListView_Previews: PreviewProvider {
    static var previews: some View {
        CurriculumListView()
            .environmentObject(SidebarViewModel())
            .environmentObject(CurriculumViewModel())
            .environmentObject(UIMetrics())
            .environmentObject(SettingsViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
