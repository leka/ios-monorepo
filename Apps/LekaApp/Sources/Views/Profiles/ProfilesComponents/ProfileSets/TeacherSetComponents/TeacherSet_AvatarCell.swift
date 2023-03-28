//
//  TeacherSet_AvatarCell.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 23/3/23.
//

import SwiftUI

struct TeacherSet_AvatarCell: View {

	@EnvironmentObject var company: CompanyViewModel
	@EnvironmentObject var settings: SettingsViewModel
	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var metrics: UIMetrics

	let teacher: Teacher

	var body: some View {
		Button {
			withAnimation {
				company.selectedProfiles[.teacher] = teacher.id
			}
			if settings.companyIsLoggingIn {
				company.assignCurrentProfiles()
				settings.companyIsLoggingIn = false
				viewRouter.currentPage = .home
			}
		} label: {
			VStack(spacing: 0) {
				ZStack(alignment: .topTrailing) {
					// Selection Indicator
					selectionIndicator(id: teacher.id)
					// Avatar
					Circle()
						.fill(
							Color("lekaLightGray"),
							strokeBorder: .white,
							lineWidth: 3
						)
						.overlay(content: {
							Image(teacher.avatar)
								.resizable()
								.aspectRatio(contentMode: .fill)
								.clipShape(Circle())
								.padding(2)
						})
				}
				.frame(height: 108)
				.padding(10)

				Text(teacher.name)
					.font(metrics.reg15)
					.allowsTightening(true)
					.lineLimit(2)
					.padding(.horizontal, 14)
					.foregroundColor(
						company.profileIsCurrent(.teacher, id: teacher.id) ? Color.white : Color("darkGray")
					)
					.padding(2)
					.frame(minWidth: 108)
					.background(content: {
						RoundedRectangle(cornerRadius: metrics.btnRadius)
							.stroke(.white, lineWidth: 2)
					})
					.background(
						company.profileIsCurrent(.teacher, id: teacher.id)
							? Color("lekaSkyBlue") : Color("lekaLightGray"),
						in: RoundedRectangle(cornerRadius: metrics.btnRadius))
			}
		}
		.buttonStyle(NoFeedback_ButtonStyle())
	}

	private func selectionIndicator(id: UUID) -> some View {
		// TODO(@ladislas): review logic in the future
		let lineWidth: CGFloat = {
			guard company.selectedProfiles[.teacher] == id else {
				guard company.profileIsCurrent(.teacher, id: id) else {
					return 0
				}
				return 10
			}
			return 10
		}()

		let dash: [CGFloat] = {
			guard company.profileIsCurrent(.teacher, id: id) else {
				return [10, 4]
			}
			return [10, 0]
		}()

		return Circle()
			.stroke(
				Color("lekaSkyBlue"),
				style: StrokeStyle(
					lineWidth: lineWidth,
					lineCap: .butt,
					lineJoin: .round,
					dash: dash))
	}
}
