//
//  SidebarAvatarView.swift
//  LekaApp
//
//  Created by Mathieu Jeannot on 24/10/23.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct SidebarAvatarView: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel

    let type: UserType

    var body: some View {
        Circle()
            .fill(Color.accentColor)
            .overlay(
                Image(
                    company.getProfileDataFor(
                        type,
                        id: company.profilesInUse[type]!
                    )[0]
                )
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            )
            .overlay(
                Circle()
                    .fill(.black)
                    .opacity(settings.exploratoryModeIsOn ? 0.3 : 0)
            )
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 4)
            }
    }
}

#Preview {
    SidebarAvatarView(type: .teacher)
}
