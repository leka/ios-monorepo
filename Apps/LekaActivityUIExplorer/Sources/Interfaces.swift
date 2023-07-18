//
//  Interfaces.swift
//  LekaActivityUIExplorer
//
//  Created by Mathieu Jeannot on 18/7/23.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Foundation
import SwiftUI

enum Interfaces: String, Codable, CaseIterable {
    case touch1, touch2, touch3, touch3Inline, touch4, touch4Inline, touch5
    case touch6 = "icons_Curriculum_Receptive--language_activity-6"
    case soundTouch1, soundTouch2, soundTouch3, soundTouch3Inline, soundTouch4, soundTouch4Inline
    case soundTouch6 = "icons_Curriculum_Receptive--language_activity-1"
    case basket1 = "icons_Curriculum_Improving--categorization_activity-1"
    case basket2 = "icons_Curriculum_Improving--categorization_activity-2"
    case basket4 = "icons_Curriculum_Improving--categorization_activity-3"
    case basketEmpty = "icons_Curriculum_Improving--categorization_activity-4"
    case dropArea1 = "icons_Curriculum_Improving--categorization_activity-8"
    case dropArea3 = "icons_Curriculum_Improving--categorization_activity-11"
    case dropArea2Asset1 = "icons_Curriculum_Improving--categorization_activity-9"
    case dropArea2Assets2 = "icons_Curriculum_Improving--categorization_activity-10"
    case dropArea2Assets6 = "icons_Curriculum_Improving--categorization_activity-12"
    case association4 = "icons_Curriculum_Improving--categorization_activity-5"
    case association6 = "icons_Curriculum_Improving--categorization_activity-6"
    case colorQuest1 = "icones_activities_Color-quest_1"
    case colorQuest2 = "icones_activities_Color-quest_2"
    case colorQuest3 = "icones_activities_Color-quest_3"
    case remoteStandard = "icones_activities_Standard-remote"
    case remoteArrow = "icones_activities_Colored-arrows"
    case xylophone = "icones_activities_Xylophone"
    case danceFreeze = "icones_activities_Freeze_dance"
    case hideAndSeek = "icones_activities_Hide-and-seek"
    case melody1 = "icones_activities_Colors-and-sound"
}
