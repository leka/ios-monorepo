//
//  SettingsSection_Profiles.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 16/3/23.
//

import SwiftUI

struct SettingsSection_Profiles: View {

	@EnvironmentObject var company: CompanyViewModel
	@EnvironmentObject var metrics: UIMetrics

	var body: some View {
		Section {
			Group {
				avatarsRow(.teacher)
				avatarsRow(.user)
			}
			.frame(maxHeight: 52)
		} header: {
			Text("Profils")
				.font(metrics.reg15)
				.foregroundColor(.accentColor)
				.headerProminence(.increased)
		}
	}

	private func avatar(_ name: String) -> some View {
		Image(name)
			.resizable()
			.aspectRatio(contentMode: .fill)
			.frame(maxWidth: 30)
			.background(Color.accentColor)
			.clipShape(Circle())
			.overlay(Circle().stroke(.white, lineWidth: 2))
	}

	private func remainingProfiles(_ remainder: Int) -> some View {
		Circle()
			.fill(Color.accentColor)
			.frame(maxWidth: 30)
			.overlay(
				Text("+\(remainder)")
					.foregroundColor(.white)
					.font(metrics.reg12)
					.clipShape(Circle())
			)
			.overlay(Circle().stroke(.white, lineWidth: 2))
	}

	private func avatarsRow(_ type: UserType) -> some View {
		LabeledContent {
			HStack(spacing: -10) {
				ForEach(company.getAllAvatarsOf(type).prefix(10), id: \.self) { item in
					avatar(item.first!.value)
				}
				if company.getAllAvatarsOf(type).count > 10 {
					let remainder: Int = company.getAllAvatarsOf(type).count - 10
					remainingProfiles(remainder)
				}
				Spacer()
			}
			.frame(minWidth: 320, maxWidth: 320)
		} label: {
			Text(
				"Profils \(type == .teacher ? "accompagnants" : "utilisateurs") (\(company.getAllAvatarsOf(type).count))"
			)
			.foregroundColor(Color("darkGray"))
		}
	}
}
