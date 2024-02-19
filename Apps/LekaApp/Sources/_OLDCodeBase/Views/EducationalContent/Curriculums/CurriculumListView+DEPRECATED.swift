// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CurriculumListViewDeprecated

struct CurriculumListViewDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var navigationVM: NavigationViewModelDeprecated
    @EnvironmentObject var curriculumVM: CurriculumViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVGrid(columns: self.columns) {
                        ForEach(CurriculumCategories.allCases, id: \.self) { category in
                            Section {
                                self.allCurriculums(category: category)
                            } header: {
                                self.headerViews(title: self.curriculumVM.getCurriculumList(category: category).sectionTitle)
                            }
                        }
                    }
                }
                .animation(.easeOut(duration: 0.4), value: self.navigationVM.showInfo())
                .safeAreaInset(edge: .top) {
                    InfoTileManagerDeprecated()
                }
                .onAppear {
                    withAnimation { proxy.scrollTo(self.curriculumVM.currentCurriculumCategory, anchor: .top) }
                }
            }
        }
        .navigationDestination(
            for: String.self,
            destination: { _ in
                CurriculumDetailsViewDeprecated()
            }
        )
    }

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 3)

    @ViewBuilder
    private func allCurriculums(category: CurriculumCategories) -> some View {
        let list: [Curriculum] = self.curriculumVM.getCurriculumsFrom(category: category)
        ForEach(list.enumerated().map { $0 }, id: \.element.id) { index, item in
            Button {
                self.curriculumVM.currentCurriculumCategory = category
                self.curriculumVM.populateCurriculumList(category: category)
                self.curriculumVM.selectedCurriculum = index
                self.navigationVM.pathsFromHome.append("curriculumDetail")
            } label: {
                CurriculumPillShapedView(
                    curriculum: item, // Integrate rank and icon within curriculum Type, delete following properties
                    icon: self.curriculumVM.setCurriculumIcon(for: item)
                )
            }
            .padding()
        }
    }

    private func headerViews(title: LocalizedContent) -> some View {
        HStack {
            Text(title.localized())
                .font(.body)
                .padding(16)
                .padding(.leading, 20)
            Spacer()
        }
    }
}

// MARK: - CurriculumListView_Previews

struct CurriculumListView_Previews: PreviewProvider {
    static var previews: some View {
        CurriculumListViewDeprecated()
            .environmentObject(NavigationViewModelDeprecated())
            .environmentObject(CurriculumViewModelDeprecated())
            .environmentObject(UIMetrics())
            .environmentObject(SettingsViewModelDeprecated())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
