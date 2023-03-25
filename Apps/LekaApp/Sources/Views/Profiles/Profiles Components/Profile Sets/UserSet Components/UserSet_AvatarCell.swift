//
//  UserSet_AvatarCell.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 23/3/23.
//

import SwiftUI

struct UserSet_AvatarCell: View {

	@EnvironmentObject var company: CompanyViewModel
	@EnvironmentObject var settings: SettingsViewModel
	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var metrics: UIMetrics

	let of: User

	var body: some View {
		Button {
			withAnimation {
				company.selectedProfiles[.user] = of.id
			}
			// Next context is within the userSelector right before launching a game
			if viewRouter.currentPage != .profiles {
				company.assignCurrentProfiles()
				if viewRouter.currentPage == .curriculumDetail {
					viewRouter.goToGameFromCurriculums = true
				} else {
					viewRouter.goToGameFromActivities = true
				}
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					viewRouter.showUserSelector = false
				}
			}
		} label: {
			VStack(spacing: 0) {
				ZStack(alignment: .topTrailing) {
					// Selection Indicator
					selectionIndicator(id: of.id)
					// Avatar
					Circle()
						.fill(
							Color("lekaLightGray"),
							strokeBorder: .white,
							lineWidth: 3
						)
						.overlay(content: {
							Image(of.avatar)
								.resizable()
								.aspectRatio(contentMode: .fill)
								.clipShape(Circle())
								.padding(2)
						})
					// Reinforcer Badge
					ZStack(alignment: .topTrailing) {
						Circle()
							.fill(Color("lekaLightGray"))
						Image("reinforcer-\(of.reinforcer)")
							.resizable()
							.renderingMode(.original)
							.aspectRatio(contentMode: .fit)
							.padding(2)
							.background(Color("lekaLightGray"), in: Circle())

						Circle()
							.stroke(.white, lineWidth: 3)
					}
					.frame(maxWidth: 40, maxHeight: 40)
					.offset(x: 6, y: -6)
				}
				.frame(height: 108)
				.padding(10)

				Text(of.name)
					.font(metrics.reg15)
					.allowsTightening(true)
					.lineLimit(2)
					.padding(.horizontal, 14)
					.foregroundColor(company.profileIsCurrent(.user, id: of.id) ? Color.white : Color("darkGray"))
					.padding(2)
					.frame(minWidth: 108)
					.background(content: {
						RoundedRectangle(cornerRadius: metrics.btnRadius)
							.stroke(.white, lineWidth: 2)
					})
					.background(
						company.profileIsCurrent(.user, id: of.id) ? Color("lekaSkyBlue") : Color("lekaLightGray"),
						in: RoundedRectangle(cornerRadius: metrics.btnRadius))
			}
		}
		.buttonStyle(NoFeedback_ButtonStyle())
	}

	@ViewBuilder
	private func selectionIndicator(id: UUID) -> some View {
		Circle()
			.stroke(
				Color("lekaSkyBlue"),
				style: StrokeStyle(
					lineWidth: company.selectedProfiles[.user] == id
						? 10 : (company.profileIsCurrent(.user, id: id) ? 10 : 0),
					lineCap: .butt,
					lineJoin: .round,
					dash: [10, (company.profileIsCurrent(.user, id: id) ? 0 : 4)]))
		Circle()
			.stroke(
				Color("lekaSkyBlue"),
				style: StrokeStyle(
					lineWidth: company.selectedProfiles[.user] == id
						? 10 : (company.profileIsCurrent(.user, id: id) ? 10 : 0),
					lineCap: .butt,
					lineJoin: .round,
					dash: [10, (company.profileIsCurrent(.user, id: id) ? 0 : 4)])
			)
			.frame(maxWidth: 40, maxHeight: 40)
			.offset(x: 6, y: -6)
	}
}
