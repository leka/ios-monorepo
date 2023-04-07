//
//  AnswersSize.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 6/4/23.
//

import SwiftUI

struct AnswersSize: View {

	@EnvironmentObject var gameEngine: GameEngine
	@EnvironmentObject var defaults: GLT_Defaults

	@State private var size = 0
	@State private var spacing = 0

	var body: some View {
		Section {
			Group {
				editSize
				editSpacing
			}
		} header: {
			Text("Taille & Espacement des réponses")
				.foregroundColor(.accentColor)
				.headerProminence(.increased)
		}
		.onChange(
			of: gameEngine.bufferActivity,
			perform: { _ in
				size = Int(defaults.playGridBtnSize)
				spacing = Int(defaults.cellSpacing)
			})
	}

	private var editSize: some View {
		LabeledContent {
			TextField("", value: $size, format: .number)
				.keyboardType(.decimalPad)
				.padding(.horizontal, 10)
				.frame(height: 34)
				.frame(minWidth: 350, maxWidth: 500)
				.foregroundColor(Color("lekaSkyBlue"))
				.background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: 8))
				.overlay(
					RoundedRectangle(cornerRadius: 8)
						.stroke(.gray.opacity(0.2), lineWidth: 1)
				)
				.onSubmit {
					defaults.playGridBtnSize = CGFloat(size)
				}
		} label: {
			Text("Taille des réponses")
				.foregroundColor(Color("lekaDarkGray"))
				.padding(.leading, 30)
		}
		.onAppear { size = Int(defaults.playGridBtnSize) }
	}

	private var editSpacing: some View {
		LabeledContent {
			TextField("", value: $spacing, format: .number)
				.keyboardType(.decimalPad)
				.padding(.horizontal, 10)
				.frame(height: 34)
				.frame(minWidth: 350, maxWidth: 500)
				.foregroundColor(Color("lekaSkyBlue"))
				.background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: 8))
				.overlay(
					RoundedRectangle(cornerRadius: 8)
						.stroke(.gray.opacity(0.2), lineWidth: 1)
				)
				.onSubmit {
					defaults.cellSpacing = CGFloat(spacing)
				}
		} label: {
			Text("Espacement")
				.foregroundColor(Color("lekaDarkGray"))
				.padding(.leading, 30)
		}
		.onAppear { spacing = Int(defaults.cellSpacing) }
	}
}
