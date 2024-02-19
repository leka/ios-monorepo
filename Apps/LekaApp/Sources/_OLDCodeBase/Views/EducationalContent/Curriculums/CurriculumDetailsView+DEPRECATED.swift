// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CurriculumDetailsViewDeprecated

struct CurriculumDetailsViewDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var curriculumVM: CurriculumViewModelDeprecated
    @EnvironmentObject var activityVM: ActivityViewModelDeprecated
    @EnvironmentObject var navigationVM: NavigationViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        self.curriculumDetailContent
    }

    // MARK: Private

    private var curriculumDetailContent: some View {
        ZStack(alignment: .top) {
            // NavigationBar color
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

            // Background Color (only visible under the header here)
            DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor

            VStack(spacing: 0) {
                self.curriculumDetailHeader
                HStack(spacing: 0) {
                    self.curriculumActivityList
                    // Instructions + GoBtn
                    Rectangle()
                        .fill(DesignKitAsset.Colors.lekaLightGray.swiftUIColor)
                        .edgesIgnoringSafeArea(.bottom)
                        .overlay { InstructionsViewDeprecated() }
                        .overlay {
                            GoButton()
                                .disabled(self.goButtonIsDisabled())
                        }
                }
            }
        }
        .preferredColorScheme(.light)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbarBackground(.automatic, for: .navigationBar)
        .onAppear { self.navigationVM.sidebarVisibility = .detailOnly }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(self.curriculumVM.setCurriculumDetailNavTitle())
                    .font(.headline)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        self.navigationVM.pathsFromHome = .init()
                    },
                    label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Retour")
                        }
                    }
                )
            }
        }
    }

    private var curriculumDetailHeader: some View {
        HStack {
            Spacer()
            VStack(spacing: 20) {
                Text(self.curriculumVM.selectedCurriculumHeaderTitle)
                    .font(.title2)
                    .padding(.top, 15)
                Image(self.curriculumVM.selectedCurriculumIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 66)
                Text(self.curriculumVM.selectedCurriculumDescription)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .foregroundColor(.white)
            Spacer()
        }
        .frame(height: 258)
    }

    private var curriculumActivityList: some View {
        ScrollViewReader { proxy in
            List(self.curriculumVM.currentCurriculum.activities.enumerated().map { $0 }, id: \.element) { index, item in
                Button {
                    self.curriculumVM.currentCurriculumSelectedActivityID = UUID(uuidString: self.activityVM.getActivity(item).id)
                    self.activityVM.currentActivity = self.activityVM.getActivity(item)
                } label: {
                    ActivityListCell_CurriculumsDeprecated(
                        activity: self.activityVM.getActivity(item),
                        icon: item,
                        rank: index + 1,
                        selected: self.curriculumVM.currentCurriculumSelectedActivityID
                            == UUID(uuidString: self.activityVM.getActivity(item).id)
                    )
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    0
                }
                .buttonStyle(NoFeedback_ButtonStyleDeprecated())
                .contentShape(Rectangle())
                .id(UUID(uuidString: self.activityVM.getActivity(item).id))
            }
            .listStyle(PlainListStyle())
            .padding(.bottom, 20)
            .background(.white, in: Rectangle())
            .edgesIgnoringSafeArea([.bottom])
            .onAppear {
                guard self.curriculumVM.currentCurriculumSelectedActivityID != nil else {
                    return
                }
                withAnimation { proxy.scrollTo(self.curriculumVM.currentCurriculumSelectedActivityID, anchor: .top) }
            }
        }
    }

    private func goButtonIsDisabled() -> Bool {
        !self.curriculumVM.currentCurriculum.activities.map { UUID(uuidString: self.activityVM.getActivity($0).id) }
            .contains(self.curriculumVM.currentCurriculumSelectedActivityID)
    }
}

// MARK: - ContextualActivitiesDetailsView_Previews

struct ContextualActivitiesDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CurriculumDetailsViewDeprecated()
            .environmentObject(CurriculumViewModelDeprecated())
            .environmentObject(ActivityViewModelDeprecated())
            .environmentObject(UIMetrics())
            .environmentObject(NavigationViewModelDeprecated())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
