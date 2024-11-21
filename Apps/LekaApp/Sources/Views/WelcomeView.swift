// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import AVKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - WelcomeView

struct WelcomeView: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    @State var player = AVPlayer(url: Bundle.main.url(forResource: "leka-loop", withExtension: "mp4")!)

    var body: some View {
        ZStack {
            VideoPlayer(player: self.player)
                .allowsHitTesting(false)
                .aspectRatio(contentMode: .fill)
                .frame(height: 2000)

            VStack(spacing: 30) {
                LekaLogo(height: 90)

                NavigationLink(String(l10n.WelcomeView.createAccountButton.characters)) {
                    AccountCreationView()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink(String(l10n.WelcomeView.loginButton.characters)) {
                    ConnectionView()
                }
                .buttonStyle(.bordered)
            }
        }
        .fullScreenCover(isPresented: self.$navigation.navigateToAccountCreationProcess) {
            AccountCreationProcess.CarouselView()
                .navigationBarBackButtonHidden()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(String(l10n.WelcomeView.skipStepButton.characters)) {
                    AnalyticsManager.shared.logEventSkipAuthentication()
                    self.dismiss()
                }
            }
        }
        .onAppear {
            self.authManagerViewModel.userAction = .none
            self.setupVideo()
        }
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private func setupVideo() {
        self.player.play()

        // loop video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil) { _ in
            self.player.seek(to: .zero)
            self.player.play()
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
