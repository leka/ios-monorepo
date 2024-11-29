// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics
import Foundation

public extension AnalyticsManager {
    // MARK: - Caregiver

    static func logEventCaregiverCreate(id: String, parameters: [String: Any] = [:]) {
        let params: [String: Any] = [
            "lk_caregiver_id_created": id,
        ].merging(parameters) { _, new in new }

        logEvent(.caregiverCreate, parameters: params)
    }

    static func logEventCaregiverEdit(caregiver: String, parameters: [String: Any] = [:]) {
        let params: [String: Any] = [
            "lk_caregiver_id_edited": caregiver,
        ].merging(parameters) { _, new in new }

        logEvent(.caregiverEdit, parameters: params)
    }

    static func logEventCaregiverSelect(from previous: String?, to new: String, parameters: [String: Any] = [:]) {
        let params: [String: Any] = [
            "lk_caregiver_id_previous": previous ?? NSNull(),
            "lk_caregiver_id_selected": new,
        ].merging(parameters) { _, new in new }

        logEvent(.caregiverSelect, parameters: params)
    }

    // MARK: - Carereceiver

    static func logEventCarereceiverCreate(id: String, parameters: [String: Any] = [:]) {
        let params: [String: Any] = [
            "lk_carereceiver_id_created": id,
        ].merging(parameters) { _, new in new }

        logEvent(.carereceiverCreate, parameters: params)
    }

    static func logEventCarereceiverEdit(carereceivers: String, parameters: [String: Any] = [:]) {
        let params: [String: Any] = [
            "lk_carereceiver_id_edited": carereceivers,
        ].merging(parameters) { _, new in new }

        logEvent(.carereceiverEdit, parameters: params)
    }

    static func logEventCarereceiversSelect(carereceivers: [String], parameters: [String: Any] = [:]) {
        let carereceiversString = carereceivers.joined(separator: ",")

        let params: [String: Any] = [
            "lk_carereceivers_ids_selected": carereceiversString,
        ].merging(parameters) { _, new in new }

        logEvent(.carereceiversSelect, parameters: params)
    }

    static func logEventCarereceiverSkipSelect(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        logEvent(.carereceiverSkipSelect, parameters: params)
    }
}
