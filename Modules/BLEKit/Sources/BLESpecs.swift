// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CoreBluetooth
import Foundation

// swiftlint:disable nesting

public enum BLESpecs {
    public enum AdvertisingData {
        public static let service = CBUUID(string: "0xDFB0")
    }

    public enum DeviceInformation {
        public enum Characteristics {
            public static let manufacturer = CBUUID(string: "0x2A29")
            public static let modelNumber = CBUUID(string: "0x2A24")
            public static let serialNumber = CBUUID(string: "0x2A25")
            public static let osVersion = CBUUID(string: "0x2A26")
        }

        public static let service = CBUUID(string: "0x180A")
    }

    public enum Battery {
        public enum Characteristics {
            public static let level = CBUUID(string: "0x2A19")
        }

        public static let service = CBUUID(string: "0x180F")
    }

    public enum Monitoring {
        public enum Characteristics {
            public static let chargingStatus = CBUUID(string: "0x6783")
            public static let screensaverEnable = CBUUID(string: "0x8369")
            public static let softReboot = CBUUID(string: "0x8382")
            public static let hardReboot = CBUUID(string: "0x7282")
            public static let negotiatedMTU = CBUUID(data: Data("NEGOTIATED_MTU".utf8) + Data([0, 0]))
        }

        public static let service = CBUUID(string: "0x7779")
    }

    public enum Config {
        public enum Characteristics {
            public static let robotName = CBUUID(string: "8278")
        }

        public static let service = CBUUID(string: "0x6770")
    }

    public enum MagicCard {
        public enum Characteristics {
            public static let id = CBUUID(data: Data("ID".utf8) + Data([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]))
            public static let language = CBUUID(data: Data("Language".utf8) + Data([0, 0, 0, 0, 0, 0, 0, 0]))
        }

        public static let service = CBUUID(data: Data("Magic Card".utf8 + Data([0, 0, 0, 0, 0, 0])))
    }

    public enum FileExchange {
        public enum Characteristics {
            public static let setState = CBUUID(string: "0x8383")
            public static let filePath = CBUUID(string: "0x7080")
            public static let clearFile = CBUUID(string: "0x6770")
            public static let fileReceptionBuffer = CBUUID(string: "0x8283")
            public static let fileSHA256 = CBUUID(string: "0x7083")
        }

        public static let service = CBUUID(string: "0x8270")
    }

    public enum FirmwareUpdate {
        public enum Characteristics {
            public static let requestUpdate = CBUUID(string: "0x8285")
            public static let requestFactoryReset = CBUUID(string: "0x8270")
            public static let versionMajor = CBUUID(string: "0x7765")
            public static let versionMinor = CBUUID(string: "0x7773")
            public static let versionRevision = CBUUID(string: "0x8269")
        }

        public static let service = CBUUID(string: "0x7085")
    }

    public enum Commands {
        public enum Characteristics {
            public static let tx = CBUUID(string: "0xDFB1")
        }

        public static let service = CBUUID(string: "0xDFB0")
    }
}

// swiftlint:enable nesting
