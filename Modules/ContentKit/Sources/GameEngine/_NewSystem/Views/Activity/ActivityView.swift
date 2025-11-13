// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - ActivityView

public struct ActivityView: View {
    // MARK: Lifecycle

    public init(activity: Activity, coordinator: ActivityCoordinator, reinforcer: Robot.Reinforcer = .rainbow) {
        self.activity = activity
        self.activityCoordinator = coordinator
        self.reinforcer = reinforcer
    }

    // MARK: Public

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 10) {
                if self.activityCoordinator.numberOfExercisesInCurrentGroup > 1 || self.activityCoordinator.numberOfGroups > 1 {
                    VStack {
                        ActivityProgressBar(coordinator: self.activityCoordinator)
                    }
                }

                self.activityCoordinator.currentExerciseView
            }
            .compositingGroup()
            .id(self.activityCoordinator.currentExerciseIndex)
            .disabled(self.activityCoordinator.isExerciseCompleted)
            .blur(radius: self.blurRadius)
            .onChange(of: self.isReinforcerPresented) {
                if self.isReinforcerPresented, self.activityCoordinator.isReinforcerAnimationEnabled {
                    withAnimation(.easeInOut.delay(0.7)) {
                        self.blurRadius = 20
                    }
                } else {
                    self.blurRadius = 0
                }
            }

            if self.isReinforcerPresented, self.activityCoordinator.isReinforcerAnimationEnabled {
                withAnimation(.easeInOut.delay(0.7)) {
                    ReinforcerView(isLastExercise: self.activityCoordinator.isLastExercise,
                                   onContinue: {
                                       self.activityCoordinator.nextExercise()
                                   },
                                   onDismiss: {
                                       self.isReinforcerPresented = false
                                   })
                }
            }

            if self.activityCoordinator.isExerciseCompleted, !self.isReinforcerPresented || !self.activityCoordinator.isReinforcerAnimationEnabled {
                ContinueButton {
                    self.activityCoordinator.nextExercise()
                }
                .transition(
                    .asymmetric(
                        insertion: .opacity.animation(.snappy.delay(0.75)),
                        removal: .identity
                    )
                )
            }
        }
        .frame(maxWidth: .infinity)
        .background(.lkBackground)
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationTitle(self.activity.details.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.isAlertPresented = true
                } label: {
                    Image(systemName: "xmark.circle")
                }
            }

            #if DEVELOPER_MODE
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.activityCoordinator.isReinforcerAnimationEnabled.toggle()
                    } label: {
                        if self.activityCoordinator.isReinforcerAnimationEnabled {
                            Image(systemName: "livephoto")
                        } else {
                            Image(systemName: "livephoto.slash")
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.activityCoordinator.previousExercise()
                    } label: {
                        Image(systemName: "arrow.backward")
                    }
                    .disabled(self.activityCoordinator.isFirstExercise)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.activityCoordinator.nextExercise()
                    } label: {
                        Image(systemName: "arrow.forward")
                    }
                    .disabled(self.activityCoordinator.isLastExercise)
                }
            #endif

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.isInfoSheetPresented.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .alert(String(l10n.ActivityView.QuitActivityAlert.title.characters), isPresented: self.$isAlertPresented) {
            Button(String(l10n.ActivityView.QuitActivityAlert.cancelButtonLabel.characters), role: .cancel, action: {
                self.isAlertPresented = false
            })
            Button(String(l10n.ActivityView.QuitActivityAlert.quitButtonLabel.characters), role: .destructive, action: {
                self.dismiss()
            })
        } message: {
            Text(l10n.ActivityView.QuitActivityAlert.message)
        }
        .sheet(isPresented: self.$isInfoSheetPresented) {
            ScrollView {
                InfoDetailsView(CurationItemModel(id: self.activity.id, name: self.activity.details.title, contentType: .activity))
                    .padding()
                    .logEventScreenView(
                        screenName: "activity_details",
                        context: .sheet,
                        parameters: [
                            "lk_activity_id": "\(self.activity.details.title)-\(self.activity.id)",
                        ]
                    )
            }
        }
        .fullScreenCover(isPresented: self.$isActivitySummaryPresented) {
            if self.activityCoordinator.completionStatus == .success {
                SuccessView()
            } else if self.activityCoordinator.completionStatus == .failure {
                FailureView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                logGEK.debug("Activity did start")
                self.activityCoordinator.activityEvent.send(.didStart)
            }
        }
        .onReceive(self.activityCoordinator.activityEvent) { event in
            switch event {
                case .didStart:
                    self.isActivitySummaryPresented = false
                    self.isReinforcerPresented = false
                case .didEnd:
                    self.isReinforcerPresented = false
                    self.isActivitySummaryPresented = true
            }
        }
        .onChange(of: self.activityCoordinator.isExerciseCompleted) {
            self.isReinforcerPresented = self.activityCoordinator.isExerciseCompleted
        }
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    @State private var blurRadius: CGFloat = 0
    @State private var isAlertPresented: Bool = false
    @State private var isInfoSheetPresented: Bool = false
    @State private var isActivitySummaryPresented: Bool = false
    @State private var isReinforcerPresented: Bool = false

    private var activityCoordinator: ActivityCoordinator
    private let reinforcer: Robot.Reinforcer
    private let activity: Activity
}

#if DEBUG

    #Preview {
        var cancellables = Set<AnyCancellable>()
        let activity = Activity.mock

        NavigationStack {
            let coordinator = ActivityCoordinator(payload: activity.payload)

            ActivityView(activity: activity, coordinator: coordinator)
                .onAppear {
                    coordinator.activityEvent
                        .receive(on: DispatchQueue.main)
                        .sink { event in
                            switch event {
                                case .didStart:
                                    logGEK.debug("Publisher - Activity did start")

                                case .didEnd:
                                    logGEK.debug("Publisher - Activity did end")
                            }
                        }
                        .store(in: &cancellables)
                }
        }
    }

#endif
