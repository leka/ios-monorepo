//
//  SidebarView.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 6/4/23.
//

import SwiftUI

struct SidebarView: View {

	@EnvironmentObject var navigator: NavigationManager
	@EnvironmentObject var configuration: GLT_Configurations
	@EnvironmentObject var gameEngine: GameEngine
	@EnvironmentObject var defaults: GLT_Defaults

	@State private var isExpanded: Bool = false
	@State private var selectedTemplate: Int = 0

	var body: some View {
		ScrollView {
			VStack(spacing: 30) {
				logoLeka
					.padding(.bottom, 50)
					.padding(.top, 10)

				Button("Éditeur") {
					navigator.diplaysEditor = true
					navigator.sidebarVisibility = .detailOnly
					configuration.preferred3AnswersLayout = .basic
					configuration.preferred4ansersLayout = .spaced
					gameEngine.bufferActivity = EmptyDataSets().makeEmptyActivity()
					gameEngine.resetActivity()
					configuration.editorIsEmpty = true
				}
				.frame(height: 32)
				.frame(maxWidth: .infinity)
				.background(Color.accentColor, in: RoundedRectangle(cornerRadius: 8))
				.padding(.horizontal, 20)

				DisclosureGroup(isExpanded: $isExpanded) {
					LazyVGrid(columns: [GridItem()]) {
						ForEach(configuration.allTemplatesPreviews.indices, id: \.self) { item in
							Button(action: {
								selectedTemplate = item
								navigator.diplaysEditor = false
								navigator.sidebarVisibility = .detailOnly
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
									setupTest(withTemplate: item)
								}
							}) {
								previewButton(configuration.allTemplatesPreviews[item])
							}
							.buttonStyle(
								TemplatePreview_ButtonStyle(
									isSelected: selectedTemplate == item,
									name: configuration.allTemplatesPreviews[item])
							)
							.padding(20)
						}
					}
					.padding(20)
				} label: {
					Text("Explorateur de templates")
						.frame(height: 32)
						.frame(maxWidth: .infinity)
						.background(Color.accentColor, in: RoundedRectangle(cornerRadius: 8))
				}
				.padding(.horizontal, 20)
			}
			.frame(maxWidth: .infinity)
			.font(defaults.semi17)
			.foregroundColor(.white)
		}
		.ignoresSafeArea(.container, edges: .top)
		.background(Color("lekaLightGray"))

	}

	private func setupTest(withTemplate: Int) {
		defaults.playGridBtnSize = 200
		defaults.cellSpacing = 32
		setupExplorerVariations(forTemplate: withTemplate)
		gameEngine.bufferActivity = ExplorerActivity(withTemplate: withTemplate).makeActivity()
		gameEngine.setupGame()
	}
	
	private func setupExplorerVariations(forTemplate: Int) {
		if forTemplate == 2 {
			configuration.preferred3AnswersLayout = .basic
		} else if forTemplate == 3 {
			configuration.preferred3AnswersLayout = .inline
		} else if forTemplate == 4 {
			configuration.preferred4ansersLayout = .basic
		} else if forTemplate == 5 {
			configuration.preferred4ansersLayout = .spaced
		} else if forTemplate == 6 {
			configuration.preferred4ansersLayout = .inline
		} else {
			configuration.preferred3AnswersLayout = .basic
			configuration.preferred4ansersLayout = .spaced
		}
	}

	private var logoLeka: some View {
		Image("lekaLogo_AFH")
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(height: 60)
			.padding(.top, 20)
	}

	private func previewButton(_ imageName: String) -> some View {
		Image(imageName)
			.resizable()
			.aspectRatio(contentMode: .fill)
	}
}

struct SidebarView_Previews: PreviewProvider {
	static var previews: some View {
		SidebarView()
			.environmentObject(GLT_Configurations())
			.environmentObject(NavigationManager())
			.environmentObject(GameEngine())
			.environmentObject(GLT_Defaults())
	}
}
