import SwiftUI

struct ContentView: View {

	@EnvironmentObject var navigator: NavigationManager
	@EnvironmentObject var gameEngine: GameEngine
	@EnvironmentObject var defaults: GLT_Defaults
	@EnvironmentObject var configuration: GLT_Configurations

	@State private var showInstructionModal: Bool = false
	@State private var navigateToConfigurator: Bool = false

	var body: some View {
		NavigationSplitView(columnVisibility: $navigator.sidebarVisibility) {
			SidebarView()
		} detail: {
			Group {
				if navigator.diplaysEditor {
					NavigationStack {
						GameView()
							//							.navigationDestination(isPresented: $navigateToConfigurator) { ActivityConfigurator() }
							.fullScreenCover(isPresented: $navigateToConfigurator, content: { ActivityConfigurator() })
					}

				} else {
					GameView()
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarBackButtonHidden()
			.toolbar {
				ToolbarItem(placement: .principal) { NavigationTitle }
				ToolbarItemGroup(placement: .navigationBarTrailing) { topBarTrailingItems }
			}
			.sheet(isPresented: $showInstructionModal) {
				CurrentActivityInstructionView()
			}
		}
		.navigationSplitViewStyle(.prominentDetail)
	}

	@ViewBuilder
	private var topBarTrailingItems: some View {
		Group {
			if navigator.diplaysEditor {
				infoButton
				configurationButton
			} else {
				infoButton
			}
		}
	}

	@ViewBuilder
	private var NavigationTitle: some View {
		HStack(spacing: 4) {
			Text(gameEngine.currentActivity.short.localized())
		}
		.font(defaults.semi17)
		.foregroundColor(.accentColor)
	}

	private var infoButton: some View {
		Button(action: {
			showInstructionModal.toggle()
		}) {
			Image(systemName: "info.circle")
				.foregroundColor(.accentColor)
		}
		.opacity(showInstructionModal ? 0 : 1)
	}

	private var configurationButton: some View {
		Button(action: {
			navigateToConfigurator.toggle()
			navigator.sidebarVisibility = .detailOnly
		}) {
			Image(systemName: "paintbrush.fill")
				.foregroundColor(.accentColor)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(NavigationManager())
			.environmentObject(GameEngine())
			.environmentObject(GLT_Defaults())
			.environmentObject(GLT_Configurations())
	}
}
