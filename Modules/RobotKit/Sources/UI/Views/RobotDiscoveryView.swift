// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI
import Version

// MARK: - RobotDiscoveryView

struct RobotDiscoveryView: View {
    // MARK: Lifecycle

    // MARK: - Public functions

    public init(discovery: RobotDiscoveryViewModel) {
        self.discovery = discovery
    }

    // MARK: Internal

    // MARK: - Views

    var body: some View {
        VStack {
            VStack(spacing: 30) {
                self.robotFace
                self.robotName
            }
            self.robotCharginStatusAndBattery
            self.robotOsVersion
        }
        .padding(.top, 30)
        .padding(.horizontal, 20)
    }

    // MARK: Private

    // MARK: - Private variables

    @State private var rotation: CGFloat = 0.0
    @State private var inset: CGFloat = 0.0
    @State private var showNotUpToDateAlert: Bool = false

    // swiftlint:disable:next force_cast
    private let isNotLekaUpdater = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as! String != "LekaUpdater"

    private var discovery: RobotDiscoveryViewModel

    private var robotNotUpToDate: Bool {
        guard let osVersion = Version(tolerant: self.discovery.osVersion) else {
            return false
        }
        let versionIsLatest = osVersion >= Version(tolerant: Robot.kLatestFirmwareVersion)!
        if versionIsLatest {
            return false
        } else {
            return true
        }
    }

    // MARK: - Private views

    private var robotFace: some View {
        Group {
            if self.discovery.isDeepSleeping {
                self.robotFaceSleeping
            } else {
                self.robotFaceSimple
            }
        }
    }

    private var robotFaceSleeping: some View {
        DesignKitAsset.Images.robotFaceSleeping.swiftUIImage
            .overlay(content: {
                Circle()
                    .inset(by: -10)
                    .stroke(
                        DesignKitAsset.Colors.lekaGreen.swiftUIColor,
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .butt,
                            lineJoin: .round,
                            dash: [12, 3]
                        )
                    )
                    .opacity(self.discovery.status == .selected ? 1 : 0)
                    .rotationEffect(.degrees(self.rotation), anchor: .center)
                    .animation(
                        Animation
                            .linear(duration: 15)
                            .repeatForever(autoreverses: false),
                        value: self.rotation
                    )
                    .onAppear {
                        self.rotation = 360
                    }
            })
            .overlay(alignment: .topTrailing) {
                if self.robotNotUpToDate {
                    Button {
                        self.showNotUpToDateAlert.toggle()
                    } label: {
                        Image(systemName: "exclamationmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.white, .red)
                    }
                    .alert(String(l10n.RobotDiscoveryView.robotNotUpToDateAlert.characters), isPresented: self.$showNotUpToDateAlert) {
                        if self.isNotLekaUpdater {
                            Button(String(l10n.RobotDiscoveryView.openLekaUpdaterAlertAction.characters)) {
                                let appURL = URL(string: "LekaUpdater://")
                                let appStoreURL = URL(string: "https://apps.apple.com/app/leka-updater/id6446940960")!

                                if let appURL, UIApplication.shared.canOpenURL(appURL) {
                                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                                }
                            }
                        }
                        Button(String(l10n.RobotDiscoveryView.closeAlertAction.characters), role: .cancel) {}
                    }
                }
            }
    }

    private var robotFaceSimple: some View {
        DesignKitAsset.Images.robotFaceSimple.swiftUIImage
            .overlay(content: {
                Circle()
                    .inset(by: -10)
                    .stroke(
                        DesignKitAsset.Colors.lekaGreen.swiftUIColor,
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .butt,
                            lineJoin: .round,
                            dash: [12, 3]
                        )
                    )
                    .opacity(self.discovery.status == .selected ? 1 : 0)
                    .rotationEffect(.degrees(self.rotation), anchor: .center)
                    .animation(
                        Animation
                            .linear(duration: 15)
                            .repeatForever(autoreverses: false),
                        value: self.rotation
                    )
                    .onAppear {
                        self.rotation = 360
                    }
            })
            .onAppear {
                guard self.discovery.status == .connected else { return }
                let baseAnimation = Animation.bouncy(duration: 0.5)
                withAnimation(baseAnimation) {
                    self.inset = -26.0
                }
            }
            .background(
                DesignKitAsset.Colors.lekaGreen.swiftUIColor.opacity(self.discovery.status == .connected ? 1.0 : 0.0),
                in: Circle().inset(by: self.inset)
            )
            .overlay(alignment: .topTrailing) {
                if self.robotNotUpToDate {
                    Button {
                        self.showNotUpToDateAlert.toggle()
                    } label: {
                        Image(systemName: "exclamationmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.white, .red)
                    }
                    .alert(String(l10n.RobotDiscoveryView.robotNotUpToDateAlert.characters), isPresented: self.$showNotUpToDateAlert) {
                        if self.isNotLekaUpdater {
                            Button(String(l10n.RobotDiscoveryView.openLekaUpdaterAlertAction.characters)) {
                                let appURL = URL(string: "LekaUpdater://")
                                let appStoreURL = URL(string: "https://apps.apple.com/app/leka-updater/id6446940960")!

                                if let appURL, UIApplication.shared.canOpenURL(appURL) {
                                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                                }
                            }
                        }
                        Button(String(l10n.RobotDiscoveryView.closeAlertAction.characters), role: .cancel) {}
                    }
                }
            }
    }

    private var robotName: some View {
        Text(self.discovery.name)
            .font(.title3)
            .multilineTextAlignment(.center)
            .lineLimit(1)
    }

    private var robotCharginStatusAndBattery: some View {
        HStack {
            if self.discovery.isCharging {
                Image(systemName: "bolt.circle.fill")
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "bolt.slash.circle")
                    .foregroundColor(.gray.opacity(0.6))
            }

            HStack(spacing: 5) {
                Image(systemName: self.discovery.battery.name)
                    .foregroundColor(self.discovery.battery.color)
                Text("\(self.discovery.battery.level)%")
                    .foregroundColor(.gray)
            }
        }
    }

    private var robotOsVersion: some View {
        Text("LekaOS \(self.discovery.osVersion)")
            .font(.caption)
            .foregroundColor(.gray)
    }
}

// MARK: - l10n.RobotDiscoveryView

extension l10n {
    enum RobotDiscoveryView {
        static let robotNotUpToDateAlert = LocalizedString(
            "robotkit.robot_discovery_view.robot_not_up_to_date_alert",
            bundle: RobotKitResources.bundle,
            value: "An update for Leka is available",
            comment: "Update is available alert"
        )

        static let openLekaUpdaterAlertAction = LocalizedString(
            "robotkit.robot_discovery_view.open_leka_updater_alert_action",
            bundle: RobotKitResources.bundle,
            value: "Open LekaUpdater",
            comment: "Redirect to LekaUpdater app"
        )

        static let closeAlertAction = LocalizedString(
            "robotkit.robot_discovery_view.close_alert_action",
            bundle: RobotKitResources.bundle,
            value: "Close",
            comment: "Close alert"
        )
    }
}

#Preview {
    HStack(spacing: 100) {
        RobotDiscoveryView(discovery: .mock(name: "Leka unselected", status: .unselected))

        RobotDiscoveryView(discovery: .mock(name: "Leka selected", status: .selected))

        RobotDiscoveryView(discovery: .mock(name: "Leka connected", status: .connected))
    }
}
