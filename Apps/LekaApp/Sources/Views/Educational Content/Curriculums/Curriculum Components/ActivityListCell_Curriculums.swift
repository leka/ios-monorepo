//
//  ActivityListCell_Curriculums.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 15/3/23.
//

import SwiftUI

struct ActivityListCell_Curriculums: View {
	@EnvironmentObject var metrics:  UIMetrics
	
	let activity: Activity
	let icon: String
	let iconDiameter: CGFloat = 100
	let rank: Int
	let selected: Bool
	
	var body: some View {
		HStack(spacing: 20) {
			iconView
			cellContent
			Spacer()
		}
		.frame(minWidth: 420, maxHeight: iconDiameter+20)
		.background(selected ? Color.accentColor : .white)
		.clipShape(RoundedRectangle(cornerRadius: metrics.btnRadius, style: .continuous))
		.padding(.vertical, 4)
	}
	
	private var iconView: some View {
		Image(icon)
			.ActivityIcon_ImageModifier(diameter: iconDiameter)
			.padding(.leading, 10)
	}
	
	private var cellContent: some View {
		VStack(alignment: .leading, spacing: 0) {
			Spacer()
			Text(activity.title.localized())
				.font(metrics.reg19)
			Spacer()
			Group{
				Text("ACTIVITÉ \(rank)")
					.font(metrics.bold15)
				+ Text(" - \(activity.short.localized())")
			}
			.font(metrics.reg15)
			.multilineTextAlignment(.leading)
			.padding(.bottom, 10)
		}
		.foregroundColor(selected ? .white : .accentColor)
	}
}
