//
//  GLT_Configurations.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/3/23.
//

import Foundation
import SwiftUI

class GLT_Configurations: ObservableObject {

	@Published var templatesScope: TemplateSelectionScope = .activity
	@Published var allUsedTemplates: [[Int]] = [[0]]
	@Published var preferred3AnswersLayout: AlternativeLayout = .basic
	@Published var preferred4ansersLayout: AlternativeLayout = .spaced

	// MARK: - Editor Data
	@Published var editorIsEmpty: Bool = true
	@Published var disableEditor: Bool = false
	@Published var testIsDisabled: Bool = true
	@Published var originalSteps: [[Step]] = []
	@Published var currentlyEditedGroupIndex: Int = 0
	@Published var currentlyEditedStepIndex: Int = 0
	@Published var navigateToTemplateSelector: Bool = false
	@Published var navigateToAlternativeTemplateSelector: Bool = false

	@Published var answerSamples = [
		"dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5", "dummy_6", "dummy_@", "dummy_&",
	]
	@Published var allTemplatesPreviews = [
		"LayoutTemplate_1", "LayoutTemplate_2", "LayoutTemplate_3", "LayoutTemplate_3_inline", "LayoutTemplate_4",
		"LayoutTemplate_4_spaced", "LayoutTemplate_4_inline", "LayoutTemplate_6",
	]
	@Published var templatesPreviews = [
		"LayoutTemplate_1", "LayoutTemplate_2", "LayoutTemplate_3", "LayoutTemplate_4_spaced", "LayoutTemplate_6",
	]
	@Published var templatesPreviewsAlternatives3 = ["LayoutTemplate_3", "LayoutTemplate_3_inline"]
	@Published var templatesPreviewsAlternatives4 = [
		"LayoutTemplate_4_spaced", "LayoutTemplate_4", "LayoutTemplate_4_inline",
	]
	@Published var typesOfActivity: [String] = ["touch_to_select", "listen_then_touch_to_select"]

	// MARK: - Setup Editor when being fed a new activity (from yaml or models)
	func setupEditor(with: Activity) {
		getInitialTemplatesScope(from: with)
		originalSteps = with.stepSequence
		// deal with templates and variants
		preferred3AnswersLayout = .basic
		preferred4ansersLayout = .spaced
		templatesPreviews[2] = templatesPreviewsAlternatives3[0]
		templatesPreviews[3] = templatesPreviewsAlternatives4[0]
	}

	func setTemplatesPerScope(for activity: Activity, to: TemplateSelectionScope) {
		switch templatesScope {
			case .activity:
				let currentTemplate = allUsedTemplates[0]
				switch to {
					case .activity:
						print("Not happening...")
					case .group:
						allUsedTemplates = Array(repeating: currentTemplate, count: activity.stepSequence.count)
					case .step:
						allUsedTemplates = []
						for (indexG, group) in activity.stepSequence.enumerated() {
							allUsedTemplates.append([])
							for _ in group {
								allUsedTemplates[indexG].append(currentTemplate[0])
							}
						}
				}
			case .group:
				let currentTemplates = allUsedTemplates
				switch to {
					case .activity:
						if uniqueTemplateIsUsed(within: activity) {
							allUsedTemplates = [[currentTemplates[0][0]]]
						} else {
							// ask which one?? impose first one??
							print("Do that later")
						}
					case .group:
						print("Not happening...")
					case .step:
						if uniqueTemplateIsUsed(within: activity) {
							allUsedTemplates = [[currentTemplates[0][0]]]
						} else {
							// ask which one per group?? impose first one??
							print("Do that later")
						}
				}
			case .step:
				print("Do that later")
		}
	}

	private func uniqueTemplateIsUsed(within: Activity) -> Bool {
		let answersPerStepArray = within.stepSequence.map({ $0.map({ $0.allAnswers.count }) })
		return answersPerStepArray.compactMap({ Set($0).count }).allSatisfy({ $0 == 1 })
	}

	private func getInitialTemplatesScope(from: Activity) {
		let allSteps = from.stepSequence.joined()
		let firstStep = from.stepSequence[0][0]
		let allOthersSteps = allSteps.dropFirst()
		if allOthersSteps.allSatisfy({ $0.allAnswers.count == firstStep.allAnswers.count }) {
			templatesScope = .activity
			allUsedTemplates = [[firstStep.allAnswers.count - 1]]
		} else {
			if uniqueTemplateIsUsed(within: from) {
				templatesScope = .group
				allUsedTemplates = []
				for group in from.stepSequence {
					allUsedTemplates.append([group[0].allAnswers.count - 1])
				}
			} else {
				templatesScope = .step
				allUsedTemplates = []
				for (indexG, group) in from.stepSequence.enumerated() {
					allUsedTemplates.append([group[0].allAnswers.count - 1])
					for (indexS, _) in group.enumerated() {
						allUsedTemplates[indexG].append(group[indexS].allAnswers.count - 1)
					}
				}
			}
		}
		print("scope is \(templatesScope)", allUsedTemplates)
	}
}
