// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct TickPic: View {
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        HStack(alignment: .top) {
            self.imageFromContext()
                .resizable()
                .renderingMode(self.settings.exploratoryModeIsOn ? .template : .original)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .padding(self.settings.exploratoryModeIsOn ? 20 : 0)
                .fontWeight(.light)
                .background(
                    self.settings.exploratoryModeIsOn ? DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor : .clear, in: Circle()
                )
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 3)
                        .opacity(self.settings.exploratoryModeIsOn ? 1 : 0)
                )
                .frame(maxWidth: self.settings.exploratoryModeIsOn ? 72 : 44)
                .offset(y: self.settings.exploratoryModeIsOn ? 4 : -4)
        }
    }

    func imageFromContext() -> Image {
        guard self.settings.exploratoryModeIsOn else {
            guard self.company.profileIsAssigned(.user) || !self.settings.companyIsConnected else {
                return DesignKitAsset.Images.cross.swiftUIImage
            }
            return DesignKitAsset.Images.tick.swiftUIImage
        }
        return Image(systemName: "binoculars.fill")
    }
}
