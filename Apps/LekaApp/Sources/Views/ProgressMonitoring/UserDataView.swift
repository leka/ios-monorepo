//
//  UserDataView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 28/11/22.
//

import SwiftUI

// This is a temporary View to test the design
struct UserDataView: View {

    @EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var company: CompanyViewModel

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()

            List(0...company.willBeDeletedFakeFollowUpNumberOfCells, id: \.self) { item in
                UserDataCell(successValue: $sidebar.successValues[item])
                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                        return 0
                    }
            }
            .listStyle(PlainListStyle())
            .padding(.bottom, 20)
            .background(.white, in: Rectangle())
            .edgesIgnoringSafeArea(.bottom)
            .safeAreaInset(edge: .top) {
                InfoTileManager()
            }
        }
        .animation(.easeOut(duration: 0.4), value: sidebar.showInfo())
    }
}
