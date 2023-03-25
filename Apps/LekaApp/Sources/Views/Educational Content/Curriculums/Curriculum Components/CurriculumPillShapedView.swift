//
//  CurriculumPillShapedView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 16/11/22.
//

import SwiftUI

struct CurriculumPillShapedView: View {

	@EnvironmentObject var metrics: UIMetrics

	var curriculum: Curriculum
	var icon: String
	var rank: String

	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				topContent
				bottomContent
			}
			.frame(width: 200, height: 240)
			.clipShape(RoundedRectangle(cornerRadius: metrics.pillRadius, style: .continuous))
			.shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
			iconView
		}
		.compositingGroup()
	}

	private var iconView: some View {
		Image(icon)
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(width: 200, height: 66)
			.offset(y: 5)
	}

	private var topContent: some View {
		Rectangle()
			.fill(Color.accentColor)
			.overlay(
				ZStack(alignment: .top) {
					VStack {
						Spacer()
						Text(curriculum.title.localized())
							.multilineTextAlignment(.center)
							.font(metrics.med16)
							.padding(.bottom, 40)
					}
				}
				.foregroundColor(.white)
			)
	}

	private var bottomContent: some View {
		Rectangle()
			.fill(Color.white)
			.overlay(
				VStack {
					Text(curriculum.subtitle.localized())
						.multilineTextAlignment(.center)
						.allowsTightening(true)
						.font(metrics.med14)
						.padding(.top, 50)
						.padding(.horizontal, 10)
					Spacer()
					Text(rank)
						.font(metrics.med12)
						.padding(.bottom, 12)
				}
				.foregroundColor(Color("darkGray"))
			)
	}
}
