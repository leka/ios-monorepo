// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct TickPic: View {
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel

    func imageFromContext() -> Image {
        guard settings.exploratoryModeIsOn else {
            guard company.profileIsAssigned(.user) || !settings.companyIsConnected else {
                return DesignKitAsset.Images.cross.swiftUIImage
            }
            return DesignKitAsset.Images.tick.swiftUIImage
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
                .background(
                    settings.exploratoryModeIsOn ? DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor : .clear, in: Circle()
                )
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
