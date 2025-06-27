// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics
import Foundation

public extension AnalyticsManager {
    // MARK: - Activities

    static func logEventSharedLibraryAddActivity(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_activity_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryAddActivity, parameters: params)
    }

    static func logEventSharedLibraryRemoveActivity(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_activity_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryRemoveActivity, parameters: params)
    }

    static func logEventSharedLibraryAddActivityToFavorites(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_activity_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryAddActivityToFavorites, parameters: params)
    }

    static func logEventSharedLibraryRemoveActivityFromFavorites(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_activity_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryRemoveActivityFromFavorites, parameters: params)
    }

    // MARK: - Curriculums

    static func logEventSharedLibraryAddCurriculum(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_curriculum_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryAddCurriculum, parameters: params)
    }

    static func logEventSharedLibraryRemoveCurriculum(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_curriculum_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryRemoveCurriculum, parameters: params)
    }

    static func logEventSharedLibraryAddCurriculumToFavorites(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_curriculum_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryAddCurriculumToFavorites, parameters: params)
    }

    static func logEventSharedLibraryRemoveCurriculumFromFavotites(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_curriculum_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryRemoveCurriculumFromFavorites, parameters: params)
    }

    // MARK: - Stories

    static func logEventSharedLibraryAddStory(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_story_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryAddStory, parameters: params)
    }

    static func logEventSharedLibraryRemoveStory(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_story_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryRemoveStory, parameters: params)
    }

    static func logEventSharedLibraryAddStoryToFavotites(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_story_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryAddStoryToFavorites, parameters: params)
    }

    static func logEventSharedLibraryRemoveStoryFromFavotites(
        id: String,
        name: String,
        caregiver: String,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_story_id": "\(name)-\(id)",
            "lk_caregiver_id": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.sharedLibraryRemoveStoryFromFavorites, parameters: params)
    }
}
