//
//  TickPic.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 17/3/23.
//

import SwiftUI

struct TickPic: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel

    func imageFromContext() -> Image {
        guard settings.exploratoryModeIsOn else {
            guard company.profileIsAssigned(.user) || !settings.companyIsConnected else {
                return Image("cross")
            }
            return Image("tick")
        }
        return Image(systemName: "binoculars.fill")
    }

    var body: some View {
        HStack(alignment: .top) {
            imageFromContext()
                .resizable()
                .renderingMode(settings.exploratoryModeIsOn ? .template : .original)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .padding(settings.exploratoryModeIsOn ? 20 : 0)
                .fontWeight(.light)
                .background(settings.exploratoryModeIsOn ? Color("lekaSkyBlue") : .clear, in: Circle())
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 3)
                        .opacity(settings.exploratoryModeIsOn ? 1 : 0)
                )
                .frame(maxWidth: settings.exploratoryModeIsOn ? 72 : 44)
                .offset(y: settings.exploratoryModeIsOn ? 4 : -4)
        }
    }
}
