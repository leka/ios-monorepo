// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DeviceKit

public extension Device {
    enum IpadDisplaySize: CaseIterable {
        case small // iPad mini family (8.3")
        case medium // iPad (9.7–10.9"), iPad Air (10.5–13"), iPad Pro 9–11"
        case large // iPad Pro 12.9–13"
    }

    func getDeviceSize() -> IpadDisplaySize {
        switch self.resolvedForSimulator {
            case .iPadMini,
                 .iPadMini2,
                 .iPadMini3,
                 .iPadMini4,
                 .iPadMini5,
                 .iPadMini6,
                 .iPadMiniA17Pro:
                .small

            case .iPad2,
                 .iPad3,
                 .iPad4,
                 .iPad5,
                 .iPad6,
                 .iPad7,
                 .iPad8,
                 .iPad9,
                 .iPad10,
                 .iPadA16,
                 .iPadAir,
                 .iPadAir2,
                 .iPadAir3,
                 .iPadAir4,
                 .iPadAir5,
                 .iPadAir11M2,
                 .iPadAir13M2,
                 .iPadAir11M3,
                 .iPadAir13M3,
                 .iPadPro9Inch,
                 .iPadPro10Inch,
                 .iPadPro11Inch,
                 .iPadPro11Inch2,
                 .iPadPro11Inch3,
                 .iPadPro11Inch4,
                 .iPadPro11M4:
                .medium

            case .iPadPro12Inch,
                 .iPadPro12Inch2,
                 .iPadPro12Inch3,
                 .iPadPro12Inch4,
                 .iPadPro12Inch5,
                 .iPadPro12Inch6,
                 .iPadPro13M4:
                .large

            default:
                .medium
        }
    }

    func isIpad(ofSize size: IpadDisplaySize) -> Bool {
        size == self.getDeviceSize()
    }

    static func getIpadDevices(for size: IpadDisplaySize) -> [Device] {
        switch size {
            case .small:
                [
                    .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4,
                    .iPadMini5, .iPadMini6, .iPadMiniA17Pro,
                ]
            case .medium:
                [
                    .iPad2, .iPad3, .iPad4,
                    .iPad5, .iPad6, .iPad7, .iPad8, .iPad9, .iPad10, .iPadA16,
                    .iPadAir, .iPadAir2, .iPadAir3, .iPadAir4, .iPadAir5,
                    .iPadAir11M2, .iPadAir13M2, .iPadAir11M3, .iPadAir13M3,
                    .iPadPro9Inch, .iPadPro10Inch,
                    .iPadPro11Inch, .iPadPro11Inch2, .iPadPro11Inch3, .iPadPro11Inch4, .iPadPro11M4,
                ]
            case .large:
                [
                    .iPadPro12Inch, .iPadPro12Inch2, .iPadPro12Inch3,
                    .iPadPro12Inch4, .iPadPro12Inch5, .iPadPro12Inch6,
                    .iPadPro13M4,
                ]
        }
    }

    // MARK: - Internals

    private var resolvedForSimulator: Device {
        if case let .simulator(model) = self { return model }
        return self
    }
}
