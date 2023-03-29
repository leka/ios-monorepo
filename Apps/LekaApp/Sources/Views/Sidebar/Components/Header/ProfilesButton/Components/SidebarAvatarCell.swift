//
//  SidebarAvatarCell.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 17/3/23.
//

import SwiftUI

struct SidebarAvatarCell: View {

	@EnvironmentObject var company: CompanyViewModel
	@EnvironmentObject var settings: SettingsViewModel
	@EnvironmentObject var metrics: UIMetrics

	var type: UserType
	var badge: Bool = false

	var body: some View {
		HStack {
			Spacer()
			VStack(spacing: 0) {
				ZStack(alignment: .topTrailing) {
					Circle()
						.fill(Color.accentColor)
						.overlay(
							Image(company.getProfileDataFor(type, id: company.profilesInUse[type]!)[0])
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
					if badge {
						Image("button_notification")
							.resizable()
							.renderingMode(.original)
							.aspectRatio(contentMode: .fit)
							.frame(maxWidth: 22, maxHeight: 22)
							.offset(x: 2, y: -2)
					} else if type == .user && company.profileIsAssigned(.user) {
						Image("reinforcer-\(company.getCurrentUserReinforcer())")
							.resizable()
							.renderingMode(.original)
							.aspectRatio(contentMode: .fit)
							.frame(maxWidth: settings.exploratoryModeIsOn ? 24 : 33)
							.background(.white)
							.clipShape(Circle())
							.overlay(
								Circle()
									.fill(.black)
									.opacity(settings.exploratoryModeIsOn ? 0.3 : 0)
							)
							.overlay(Circle().stroke(.white, lineWidth: 3))
							.offset(x: 6, y: settings.exploratoryModeIsOn ? -8 : -12)
					}
				}
				.frame(height: settings.exploratoryModeIsOn ? 58 : 72)
				.offset(x: settings.exploratoryModeIsOn ? (type == .teacher ? 26 : -26) : 0)
				.padding(10)

				if !settings.exploratoryModeIsOn {
					Text(company.getProfileDataFor(type, id: company.profilesInUse[type]!)[1])
						.font(metrics.reg15)
						.allowsTightening(true)
						.lineLimit(2)
						.foregroundColor(.accentColor)
						.padding(.vertical, 2)
						.padding(.horizontal, 6)
						.frame(minWidth: 100)
						.background(.white, in: RoundedRectangle(cornerRadius: metrics.btnRadius))
				}
			}
			Spacer()
		}
	}
}
