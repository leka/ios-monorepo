//
//  CurriculumActivitiesListView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 28/11/22.
//

import SwiftUI

struct CurriculumDetailsView: View {

    @EnvironmentObject var curriculumVM: CurriculumViewModel
    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics

    private func goButtonIsDisabled() -> Bool {
        return !curriculumVM.currentCurriculum.activities.map({ UUID(uuidString: activityVM.getActivity($0).id) })
            .contains(curriculumVM.currentCurriculumSelectedActivityID)
    }

    private func goButtonAction() {
        activityVM.setupGame(with: activityVM.currentActivity)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if settings.companyIsConnected && !company.selectionSetIsCorrect() {
                viewRouter.showUserSelector = true
            }
            viewRouter.goToGameFromCurriculums = true
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // NavigationBar color
                Color("lekaLightBlue").ignoresSafeArea()

                // Background Color (only visible under the header here)
                Color.accentColor

                VStack(spacing: 0) {
                    curriculumDetailHeader
                    HStack(spacing: 0) {
                        curriculumActivityList
                        // Instructions + GoBtn
                        Rectangle()
                            .fill(Color("lekaLightGray"))
                            .edgesIgnoringSafeArea(.bottom)
                            .overlay { InstructionsView() }
                            .overlay {
                                GoButton { goButtonAction() }
                                    .disabled(goButtonIsDisabled())
                            }
                    }
                }
            }
            .preferredColorScheme(.light)
            .navigationDestination(isPresented: $viewRouter.goToGameFromCurriculums) {
                if viewRouter.showUserSelector {
                    ProfileSelector_Users()
                } else {
                    GameView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.automatic, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(curriculumVM.setCurriculumDetailNavTitle())
                        .font(metrics.semi17)
                        .foregroundColor(.accentColor)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            viewRouter.currentPage = .home
                            //						curriculumVM.currentCurriculumSelectedActivityID = nil
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

    private var curriculumDetailHeader: some View {
        HStack {
            Spacer()
            VStack(spacing: 20) {
                Text(curriculumVM.selectedCurriculumHeaderTitle)
                    .font(metrics.semi17)
                    .padding(.top, 15)
                Image(curriculumVM.selectedCurriculumIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 66)
                Text(curriculumVM.selectedCurriculumDescription)
                    .font(metrics.reg17)
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
            List(curriculumVM.currentCurriculum.activities.enumerated().map({ $0 }), id: \.element) { index, item in
                Button {
                    curriculumVM.currentCurriculumSelectedActivityID = UUID(uuidString: activityVM.getActivity(item).id)
                    activityVM.currentActivity = activityVM.getActivity(item)
                } label: {
                    ActivityListCell_Curriculums(
                        activity: activityVM.getActivity(item),
                        icon: item,
                        rank: index + 1,
                        selected: curriculumVM.currentCurriculumSelectedActivityID
                            == UUID(uuidString: activityVM.getActivity(item).id))
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    return 0
                }
                .buttonStyle(NoFeedback_ButtonStyle())
                .contentShape(Rectangle())
                .id(UUID(uuidString: activityVM.getActivity(item).id))
            }
            .listStyle(PlainListStyle())
            .padding(.bottom, 20)
            .background(.white, in: Rectangle())
            .edgesIgnoringSafeArea([.bottom])
            .onAppear {
                guard curriculumVM.currentCurriculumSelectedActivityID != nil else {
                    return
                }
                withAnimation { proxy.scrollTo(curriculumVM.currentCurriculumSelectedActivityID, anchor: .top) }
            }
        }
    }
}

struct ContextualActivitiesDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CurriculumDetailsView()
            .environmentObject(CompanyViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(CurriculumViewModel())
            .environmentObject(ActivityViewModel())
            .environmentObject(UIMetrics())
            .environmentObject(ViewRouter())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
