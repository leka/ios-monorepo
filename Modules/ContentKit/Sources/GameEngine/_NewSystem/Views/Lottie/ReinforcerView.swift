// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import Lottie
import RobotKit
import SwiftUI

// MARK: - ReinforcerView

struct ReinforcerView: View {
    // MARK: Lifecycle

    init(isLastExercise: Bool, onContinue: @escaping () -> Void, onDismiss: @escaping () -> Void) {
        self.isLastExercise = isLastExercise
        self.onContinue = onContinue
        self.onDismiss = onDismiss
    }

    // MARK: Internal

    let isLastExercise: Bool
    var onContinue: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            if self.isPresented {
                LottieView(
                    animation: .reinforcer,
                    speed: 0.2
                )
                .frame(maxWidth: .infinity)
                .transition(
                    .asymmetric(
                        insertion: .opacity.animation(.snappy.delay(0.75)),
                        removal: .identity
                    )
                )
                .onAppear {
                    // TODO: (@HPezz) Implement carereceiver reinforcer
                    Robot.shared.run(.fire)
                }

                VStack(spacing: 40) {
                    Spacer()

                    Button {
                        self.onContinue()
                        self.onDismiss()
                        self.isPresented = false
                    } label: {
                        Text(self.isLastExercise ?
                            l10n.LottieAnimation.Reinforcer.finishButton :
                            l10n.LottieAnimation.Reinforcer.continueButton)
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .frame(width: 330, height: 80)
                            .background(Capsule().fill(.green).shadow(radius: 1))
                    }

                    Button(String(l10n.LottieAnimation.Reinforcer.hideReinforcerToShowAnswersButton.characters)) {
                        self.onDismiss()
                        self.isPresented = false
                    }
                    .buttonStyle(.bordered)
                    .padding(.bottom, 50)
                }
                .transition(
                    .asymmetric(
                        insertion: .opacity.animation(.snappy.delay(self.kDelayAfterReinforcerAnimation)),
                        removal: .identity
                    )
                )
            } else {
                EmptyView()
            }
        }
        .onAppear {
            withAnimation {
                self.isPresented = true
            }
        }
    }

    // MARK: Private

    @State private var isPresented: Bool = false

    // TODO: (@ladislas, @HPezz) Reduce to 3.5 when interrupting reinforcer implemented
    private var kDelayAfterReinforcerAnimation: Double = 5.0
}

#Preview {
    @Previewable @State var isReinforcerAnimationEnabled = false
    @Previewable @State var blurRadius: CGFloat = 0

    ZStack {
        Button {
            withAnimation {
                isReinforcerAnimationEnabled = true
            }
        } label: {
            CapsuleColoredButtonLabel("Trigger reinforcer", color: .blue)
        }
        .blur(radius: blurRadius)
        .onChange(of: isReinforcerAnimationEnabled) {
            if isReinforcerAnimationEnabled {
                withAnimation(.easeInOut.delay(0.5)) {
                    blurRadius = 20
                }
            } else {
                withAnimation {
                    blurRadius = 0
                }
            }
        }

        if isReinforcerAnimationEnabled {
            ReinforcerView(
                isLastExercise: false,
                onContinue: {
                    print("Continue exercise")
                },
                onDismiss: {
                    print("Dismiss exercise")
                    isReinforcerAnimationEnabled = false
                }
            )
        }
    }
}
