//
//  UserDataCell.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/11/22.
//

import SwiftUI

// Make data for this screen

struct UserDataCell: View {
	
	@EnvironmentObject var sidebar: SidebarViewModel
	@EnvironmentObject var metrics: UIMetrics
	
	@Binding var successValue: Double
	
	var body: some View {
		HStack(spacing: 0) {
			leadingTimeStatsView
			mockActivityCell
			adaptiveStatsView
		}
		.foregroundColor(.accentColor)
		.padding(.horizontal, 30)
		.allowsTightening(true)
		.contentShape(Rectangle())
	}
	
	// the following View will have to be remade after
	// decvisions have been made about rank, etc...
	// + We need to create an Activity Object to save and populate from
	private var mockActivityCell: some View {
		HStack(spacing: 30) {
			Spacer()
			
			Image("emotion_recognition-pictures-1_images_1_types-lucie-3fc7b66e-67a0-4f50-9817-9ef19af7f717")
				.ActivityIcon_ImageModifier(diameter: 100)
			
			VStack(alignment: .leading) {
				VStack(alignment: .leading, spacing: 0) {
					Text("Reconnaître des émotions")
						.font(metrics.reg16)
					Text("en photos")
						.font(metrics.reg14)
						.foregroundColor(Color("lekaDarkGray"))
					Text("activité 1 - Lucie - 1")
						.font(metrics.reg14)
						.textCase(.uppercase)
						.padding(.top, 10)
				}
			}
			.foregroundColor(.accentColor)
			.frame(minWidth: 200)
			.padding(.vertical, 10)
			
			Spacer()
		}
	}
	
	private var leadingTimeStatsView: some View {
		VStack(alignment: .leading, spacing: 10) {
			Spacer()
			Text("15/09/22")
				.font(metrics.reg17)
				.foregroundColor(.accentColor)
			
			Group {
				VStack(alignment: .leading, spacing: 0) {
					Text("heure de début")
						.font(metrics.reg12)
					Text("12h20")
						.font(metrics.med14)
				}
			}
			.foregroundColor(Color("lekaDarkGray"))
			Spacer()
		}
		.padding(.vertical, 4)
	}
	
	private var adaptiveStatsView: some View {
		ViewThatFits {
			// 1 column
			HStack(alignment: .bottom, spacing: 30) {
				Image("chrono")
					.resizable()
					.renderingMode(.template)
					.foregroundColor(Color("darkGray"))
					.aspectRatio(contentMode: .fit)
					.frame(maxWidth: 58)
					.overlay(
						VStack(spacing: 0) {
							Text("16")
							Text("min")
								.offset(y: -5)
						}
						.font(metrics.roundReg14)
						.offset(y: 5)
					)
				
				Gauge(value: successValue) {}
					.gaugeStyle(SuccessGaugeStyle())
					.font(metrics.roundReg14)
					.offset(y: -2)
				
				Spacer()
				
				HStack(spacing: 20) {
					Circle()
						.overlay(
							Image("avatars_leka_star")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.clipShape(Circle())
						)
						.frame(maxHeight: 58)
					
					Text("Aurore KIESLER")
						.font(metrics.reg16)
						.multilineTextAlignment(.leading)
				}
			}
			
			// 2 columns
			VStack(spacing: 10) {
				HStack(spacing: 20) {
					Circle()
						.overlay(
							Image("avatars_leka_star")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.clipShape(Circle())
						)
						.frame(maxHeight: 48)
					
					Text("Aurore KIESLER")
						.font(metrics.reg16)
						.multilineTextAlignment(.leading)
				}
				
				HStack(alignment: .bottom) {
					Image("chrono")
						.resizable()
						.renderingMode(.template)
						.foregroundColor(Color("darkGray"))
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: 58)
						.overlay(
							VStack(spacing: 0) {
								Text("16")
								Text("min")
									.offset(y: -5)
							}
							.font(metrics.roundReg14)
							.offset(y: 5)
						)
					Spacer()
					Gauge(value: successValue) {}
						.gaugeStyle(SuccessGaugeStyle())
						.font(metrics.roundReg14)
						.offset(y: -2)
				}
				.padding(.horizontal, 20)
			}
			.frame(minWidth: 200)
		}
		.padding(.horizontal, 20)
	}
}

struct UserDataCell_Previews: PreviewProvider {
	static var previews: some View {
		UserDataCell(successValue: .constant(0.7))
			.environmentObject(SidebarViewModel())
			.environmentObject(UIMetrics())
			.previewInterfaceOrientation(.landscapeLeft)
	}
}
