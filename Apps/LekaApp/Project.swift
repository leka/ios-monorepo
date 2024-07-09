// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let kLekaAppVersion: String = {
    guard Environment.productionBuild.getBoolean(default: false) else {
        return "999.999.999"
    }

    // ? App version
    return "1.9.0"
}()

let kGoogleServiceInfoPlistName: String = {
    if Environment.developerMode.getBoolean(default: true) {
        return "GoogleServiceInfo+DEV"
    }

    if Environment.testflightBuild.getBoolean(default: false) {
        return "GoogleServiceInfo+TESTFLIGHT"
    }

    if Environment.productionBuild.getBoolean(default: false) {
        return "GoogleServiceInfo+PROD"
    }

    return "GoogleServiceInfo+NOT_FOUND"
}()

let project = Project.app(
    name: "LekaApp",
    version: kLekaAppVersion,
    infoPlist: [
        "LSApplicationCategoryType": "public.app-category.education",
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLName": "io.leka.apf.app.LekaApp",
                "CFBundleURLSchemes": ["LekaApp"],
            ],
        ],
        "LSApplicationQueriesSchemes": ["LekaUpdater"],
        "UIBackgroundModes": [
            "bluetooth-central",
            "audio",
        ],
    ],
    settings: [
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
    ],
    scripts: TargetScript.linters() + [
        //        TargetScript.post(path: "../../Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run",
//                          arguments: "-gsp", "./Resources/GoogleFirebase/\(kGoogleServiceInfoPlistName).plist",
//                          name: "Firebase Crashlytics",
//                          inputPaths: [
//                              "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
//                              "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}",
//                              "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
//                              "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/\(kGoogleServiceInfoPlistName).plist",
//                              "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)",
//                          ]),
//        TargetScript.post(script: "cp $(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/\(kGoogleServiceInfoPlistName).plist $(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
//                          name: "Firebase Copy Info.plist"),

        TargetScript.post(tool: "cp",
                          arguments:
                          "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/\(kGoogleServiceInfoPlistName).plist",
                          "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist",
                          name: "Firebase Copy Info.plist"),

        TargetScript.post(path: "../../Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run",
                          arguments: "",
                          name: "Firebase Crashlytics",
                          inputPaths: [
                              "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
                              "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}",
                              "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
                              "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
                              "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)",
                          ]),

    ],
    dependencies: [
        .project(target: "AccountKit", path: Path("../../Modules/AccountKit")),
        .project(target: "AnalyticsKit", path: Path("../../Modules/AnalyticsKit")),
        .project(target: "ContentKit", path: Path("../../Modules/ContentKit")),
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "GameEngineKit", path: Path("../../Modules/GameEngineKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .external(name: "Yams"),
        .external(name: "MarkdownUI"),
        .external(name: "Fit"),
        .external(name: "DeviceKit"),
//        .external(name: "FirebaseAnalytics"),
//        .external(name: "FirebaseCrashlytics"),
    ]
)
