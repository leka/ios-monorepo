// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// [] TODO: (@team) - Move to iOS17 support - Name previews when relevant
// #Preview("LoadingView") {
//     LoadingView()
// }

// [] TODO: (@team) - Move to iOS17 support - Remove remaining old PreviewProviders

// [] TODO: (@team) - Move to iOS17 support - Setup Associated Domains to get autofill & strong passords in textFields

// [] TODO: (@team) - Move to iOS17 support - Use FormStyle on Forms for future proofing
// .formStyle(.grouped) seems adequat throughout the app

// [] TODO: (@team) - Move to iOS17 support - Maybe add ToggleStyle to support accentColor
// .toggleStyle(SwitchToggleStyle(tint: self.styleManager.accentColor!))

// [] TODO: (@team) - All over the app, long .onAppear, .onDisappear -> extract to func for clarity (ex: AvatarPicker())

// [] TODO: (@team) - Move to iOS17 support - Update the use of .onChange() modifier. Deprecated in iOS17
// Now accept either zero or 2 arguments in the closure
// (see CreateCaregiverView & AccountCreationView for usage example with 0 & 2 arguments)

// TODO: (@team) - Move to iOS17 support - Replace @ObservableObject/@ObservedObject with the new Observation Framework
// See CreateCaregiverView & VM for usage
// reference a property directly for one-way binding
// add $ in front of the Class name for 2-way bindings
// i.e.: $myObservableClass.propertyName ≠ myObservableClass.$propertyName (this is the syntax to access a publisher)
// No more @Published, all properties are observed unless made private
// No PropertyWrapper for one-way bindings...
// @State instead of @ObservedObject for 2-way bindings.

// TODO: (@team) - MainView lines 220-233 - Values below are defined but not used

// TODO: (@team) - Add .accessibility(identifier: "step3View")
// VoiceOver, assistive techs
// + testing Frameworks
// Double impact JCVD

// SCROLLVIEW
// TODO: (@team) - Move to iOS17 support - Remove showsIndicators argument and use modifier instead
// .scrollIndicators(.never) .automatic, .hidden, .visible
//
// Use scrollTarget environment in lists (activities, curriculum, profiles, robots, etc...)
// @Environment(\.scrollTarget) var scrollTarget
// Button("Scroll to Item") {
//     scrollTarget.scrollTo("specificItem")
// }
// using .id("specificItem") or anything identifiable other than String

// CategoryHome()
// Remove try! in init()
// Maybe create a defaultContentView()
// or a more native approach via
// ContentUnavailableView()
// https://developer.apple.com/documentation/swiftui/contentunavailableview
// https://www.avanderlee.com/swiftui/contentunavailableview-handling-empty-states/
// init() {
//     let fileURL = Bundle.main.url(forResource: "home", withExtension: "yml")!
//     let decoder = YAMLDecoder()
//
//     do {
//         let data = try Data(contentsOf: fileURL)
//         let homeContent = try decoder.decode(HomeContent.self, from: data)
//
//         if l10n.language == .french {
//             self.content = homeContent.frFR
//         } else {
//             self.content = homeContent.enUS
//         }
//     } catch {
//         print("Error loading or decoding YAML: \(error)")
//         // default content or show an error message to self.content
//         self.content = defaultContentView()
//     }
// }
