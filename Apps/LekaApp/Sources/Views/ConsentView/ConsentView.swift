// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ConsentView: View {
    // MARK: Internal

    let onCancel: () -> Void
    let onAccept: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    PrivacyPolicyView()
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 14) {
                    Divider()
                    Group {
                        Toggle(isOn: self.$isConsentGiven) {
                            Label("I have read and agree to the terms and privacy policy.", systemImage: "checkmark.shield.fill")
                        }

                        Button("Continue", action: self.onAccept)
                            .buttonStyle(.borderedProminent)
                            .disabled(!self.isConsentGiven)
                    }
                    .padding([.bottom, .horizontal])
                }
                .background(Color(.systemGray6))
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: self.onCancel)
                }
            }
        }
    }

    // MARK: Private

    @State private var isConsentGiven: Bool = false
}

// MARK: - ConsentView_Previews

#Preview {
    ConsentView(
        onCancel: {
            print("Content was declined")
        },
        onAccept: {
            print("Consent was given")
        }
    )
}
