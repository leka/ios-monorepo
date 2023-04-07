//
//  FollowUpList_Teachers.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 15/3/23.
//

import SwiftUI

struct FollowUpList_Teachers: View {

    @EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    // Delete when FollowUp is Ready
    private func simulateChange() {
        // simulate some change of profile for now
        sidebar.successValues.shuffle()
        company.willBeDeletedFakeFollowUpNumberOfCells = Int.random(in: 0...10)
    }

    var body: some View {
        ScrollViewReader { proxy in
            List(company.getAllProfilesIDFor(.teacher), id: \.self) { profile in
                Button {
                    sidebar.currentlySelectedTeacherProfile = profile
                    sidebar.contentVisibility = .detailOnly

                    simulateChange()
                } label: {
                    cellContent(id: profile)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .buttonStyle(NoFeedback_ButtonStyle())
                .id(profile)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Suivi")
            .navigationBarTitleDisplayMode(.large)
            .tint(.accentColor)
            .onAppear {
                proxy.scrollTo(sidebar.currentlySelectedTeacherProfile, anchor: .center)
            }
        }
    }

    func cellContent(id: UUID) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(
                    Color.accentColor,
                    strokeBorder: sidebar.currentlySelectedTeacherProfile == id ? .white : Color("lekaLightGray"),
                    lineWidth: 4
                )
                .overlay(
                    Image(company.getProfileDataFor(.teacher, id: id)[0])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .padding(2)
                )
                .frame(maxWidth: 60)
            Text(company.getProfileDataFor(.teacher, id: id)[1])
                .foregroundColor(sidebar.currentlySelectedTeacherProfile == id ? .white : Color.accentColor)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(sidebar.currentlySelectedTeacherProfile == id ? .white : Color("chevron"))
        }
        .font(metrics.reg17)
        .padding(10)
        .background(
            sidebar.currentlySelectedTeacherProfile == id ? Color.accentColor : .clear,
            in: RoundedRectangle(cornerRadius: metrics.btnRadius, style: .continuous)
        )
        .contentShape(Rectangle())
    }
}
