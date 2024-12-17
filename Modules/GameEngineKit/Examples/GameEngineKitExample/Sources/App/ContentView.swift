// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Text("Choose your gameplay")
                .font(.title)
                .padding()

            VStack(spacing: 10) {
                HStack(spacing: 20) {
                    Text("TTS")
                        .font(.title)
                        .padding()

                    NavigationLink("Find The Right Answers", destination: {
                        let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                        let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay)
                        let viewModel = TTSViewViewModel(coordinator: coordinator)

                        return TTSView(viewModel: viewModel)
                            .navigationTitle("Find The Right Answers")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.orange)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Find The Right Order", destination: {
                        let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultChoices)
                        let coordinator = TTSCoordinatorFindTheRightOrder(gameplay: gameplay)
                        let viewModel = TTSViewViewModel(coordinator: coordinator)

                        return TTSView(viewModel: viewModel)
                            .navigationTitle("Find The Right Order")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.green)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Associate Categories", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                        let coordinator = TTSCoordinatorAssociateCategories(gameplay: gameplay)
                        let viewModel = TTSViewViewModel(coordinator: coordinator)

                        return TTSView(viewModel: viewModel)
                            .navigationTitle("Associate Categories")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Memory", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                        let coordinator = MemoryCoordinatorAssociateCategories(gameplay: gameplay)
                        let viewModel = NewMemoryViewViewModel(coordinator: coordinator)

                        return NewMemoryView(viewModel: viewModel)
                            .navigationTitle("Memory")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Spacer()
                }

                HStack(spacing: 20) {
                    Text("Action Then TTS")
                        .font(.title)
                        .padding()

                    NavigationLink("Observe Image Then Find The Right Answers", destination: {
                        let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                        let coordinator = ActionThenTTSCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                                      action: .ipad(type: .image("sport_dance_player_man")))
                        let viewModel = ActionThenTTSViewViewModel(coordinator: coordinator)

                        return ActionThenTTSView(viewModel: viewModel)
                            .navigationTitle("Observe Image Then Find The Right Answers")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Observe SFSymbol Then Find The Right Answers", destination: {
                        let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                        let coordinator = ActionThenTTSCoordinatorFindTheRightAnswers(gameplay: gameplay, action: .ipad(type: .sfsymbol("star")))
                        let viewModel = ActionThenTTSViewViewModel(coordinator: coordinator)

                        return ActionThenTTSView(viewModel: viewModel)
                            .navigationTitle("Observe SFSymbol Then Find The Right Answers")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Listen Audio Then Find The Right Answers", destination: {
                        let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                        let coordinator = ActionThenTTSCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                                      action: .ipad(type: .audio("sound_animal_duck")))
                        let viewModel = ActionThenTTSViewViewModel(coordinator: coordinator)

                        return ActionThenTTSView(viewModel: viewModel)
                            .navigationTitle("Listen Audio Then Find The Right Answers")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Listen Speech Then Find The Right Answers", destination: {
                        let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                        let coordinator = ActionThenTTSCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                                      action: .ipad(type: .speech("Correct answer")))
                        let viewModel = ActionThenTTSViewViewModel(coordinator: coordinator)

                        return ActionThenTTSView(viewModel: viewModel)
                            .navigationTitle("Listen Speech Then Find The Right Answers")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Robot Then Find The Right Answers", destination: {
                        let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                        let coordinator = ActionThenTTSCoordinatorFindTheRightAnswers(gameplay: gameplay, action: .robot(type: .color("red")))
                        let viewModel = ActionThenTTSViewViewModel(coordinator: coordinator)

                        return ActionThenTTSView(viewModel: viewModel)
                            .navigationTitle("Robot Then Find The Right Answers")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Spacer()
                }

                HStack(spacing: 20) {
                    Text("DnD")
                        .font(.largeTitle)
                        .padding()

                    NavigationLink("Drag & Drop Categories", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                        let coordinator = DnDGridCoordinatorAssociateCategories(gameplay: gameplay)
                        let viewModel = DnDGridViewModel(coordinator: coordinator)

                        return DnDGridView(viewModel: viewModel)
                            .navigationTitle("Drag & Drop Categories")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.purple)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Drag & Drop With Zones", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoicesWithZones)
                        let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay)
                        let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                        return DnDGridWithZonesView(viewModel: viewModel)
                            .navigationTitle("Drag & Drop With Zones")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.yellow)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Drag & Drop One To One In Right Order", destination: {
                        let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultImageChoicesWithZones)
                        let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(gameplay: gameplay)
                        let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                        return DnDOneToOneView(viewModel: viewModel)
                            .navigationTitle("Drag & Drop One To One In Right Order")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.red)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Spacer()
                }

                HStack(spacing: 20) {
                    Text("Action Then DnDGrid")
                        .font(.title)
                        .padding()

                    NavigationLink("Observe Image Then Drag & Drop Categories", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                        let coordinator = DnDGridCoordinatorAssociateCategories(gameplay: gameplay,
                                                                                action: .ipad(type: .image("sport_dance_player_man")))
                        let viewModel = DnDGridViewModel(coordinator: coordinator)

                        return DnDGridView(viewModel: viewModel)
                            .navigationTitle("Observe Image Then Drag & Drop Categories")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.pink)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Observe SFSymbol Then Drag & Drop Categories", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                        let coordinator = DnDGridCoordinatorAssociateCategories(gameplay: gameplay, action: .ipad(type: .sfsymbol("star")))
                        let viewModel = DnDGridViewModel(coordinator: coordinator)

                        return DnDGridView(viewModel: viewModel)
                            .navigationTitle("Observe SFSymbol Then Drag & Drop Categories")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.pink)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Listen Then Drag & Drop Categories", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                        let coordinator = DnDGridCoordinatorAssociateCategories(gameplay: gameplay, action: .ipad(type: .audio("sound_animal_duck")))
                        let viewModel = DnDGridViewModel(coordinator: coordinator)

                        return DnDGridView(viewModel: viewModel)
                            .navigationTitle("Listen Then Drag & Drop Categories")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.pink)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Listen Speech Then Drag & Drop Categories", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultImageChoices)
                        let coordinator = DnDGridCoordinatorAssociateCategories(gameplay: gameplay, action: .ipad(type: .speech("Correct answer")))
                        let viewModel = DnDGridViewModel(coordinator: coordinator)

                        return DnDGridView(viewModel: viewModel)
                            .navigationTitle("Listen Speech  Then Drag & Drop Categories")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.pink)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Robot Then Drag & Drop Categories", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                        let coordinator = DnDGridCoordinatorAssociateCategories(gameplay: gameplay, action: .robot(type: .color("red")))
                        let viewModel = DnDGridViewModel(coordinator: coordinator)

                        return DnDGridView(viewModel: viewModel)
                            .navigationTitle("Listen Speech  Then Drag & Drop Categories")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.pink)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Spacer()
                }

                HStack(spacing: 20) {
                    Text("Action Then DnD Grid With Zones")
                        .font(.title)
                        .padding()

                    NavigationLink("Observe Image Then Drag & Drop Grid With Zones", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultImageChoicesWithZones)
                        let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay,
                                                                                         action: .ipad(type: .image("sport_dance_player_man")))
                        let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                        return DnDGridWithZonesView(viewModel: viewModel)
                            .navigationTitle("Observe Image Then Drag & Drop Grid With Zones")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Observe SFSymbol Then Drag & Drop Grid With Zones", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoicesWithZones)
                        let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay,
                                                                                         action: .ipad(type: .sfsymbol("star")))
                        let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                        return DnDGridWithZonesView(viewModel: viewModel)
                            .navigationTitle("Observe SFSymbol Then Drag & Drop Grid With Zones")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Listen Then Drag & Drop Grid With Zones", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoicesWithZones)
                        let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay,
                                                                                         action: .ipad(type: .audio("sound_animal_duck")))
                        let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                        return DnDGridWithZonesView(viewModel: viewModel)
                            .navigationTitle("Listen Then Drag & Drop Grid With Zones")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Listen Speech Then Drag & Drop Grid With Zones", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultImageChoicesWithZones)
                        let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay,
                                                                                         action: .ipad(type: .speech("Correct answer")))
                        let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                        return DnDGridWithZonesView(viewModel: viewModel)
                            .navigationTitle("Listen Speech Then Drag & Drop Grid With Zones")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    NavigationLink("Robot Then Drag & Drop Grid With Zones", destination: {
                        let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoicesWithZones)
                        let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(gameplay: gameplay,
                                                                                         action: .robot(type: .color("red")))
                        let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                        return DnDGridWithZonesView(viewModel: viewModel)
                            .navigationTitle("Listen Robot Then Drag & Drop Grid With Zones")
                            .navigationBarTitleDisplayMode(.large)
                    })
                    .tint(.cyan)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Spacer()
                }
            }

            Text("Or choose a template")
                .font(.largeTitle)
                .padding()

            ActivityTemplateList()
        }
    }
}

#Preview {
    ContentView()
}
