import SwiftUI

struct ContentView: View {

    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations

    @State private var showInstructionModal: Bool = false
    @State private var navigateToConfigurator: Bool = false
    @State private var showOptions: Bool = false

    var body: some View {
        NavigationSplitView(columnVisibility: $navigator.sidebarVisibility) {
            SidebarView()
        } detail: {
            Group {
                if navigator.diplaysEditor {
                    NavigationStack {
                        GameView()
                            .fullScreenCover(
                                isPresented: $navigateToConfigurator, content: { ActivityConfigurator() })
                    }

                } else {
                    ZStack {
                        GameView()
                        Color.black
                            .opacity(showOptions ? 0.2 : 0.0)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.4)) { showOptions = false }
                            }
                        Group {
                            if showOptions {
                                ExplorerOptionsPanel(closePanel: $showOptions)
                                    .transition(.move(edge: .trailing))
                            }
                        }
                        .animation(.easeIn(duration: 0.4), value: showOptions)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .principal) { navigationTitleView }
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
                optionsButton
            }
        }
    }

    @ViewBuilder
    private var navigationTitleView: some View {
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

    private var optionsButton: some View {
        Button(
            action: {
                withAnimation(.easeIn(duration: 0.4)) {
                    showOptions.toggle()
                }
                navigator.sidebarVisibility = .detailOnly
            },
            label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.accentColor)
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NavigationManager())
            .environmentObject(GameEngine())
            .environmentObject(GameLayoutTemplatesDefaults())
            .environmentObject(GameLayoutTemplatesConfigurations())
    }
}
