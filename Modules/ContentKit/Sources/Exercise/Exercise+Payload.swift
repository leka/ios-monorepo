// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public protocol ExercisePayloadProtocol: Codable {}

extension TouchToSelect.Payload: ExercisePayloadProtocol {}
extension DragAndDropIntoZones.Payload: ExercisePayloadProtocol {}
extension DragAndDropAssociation.Payload: ExercisePayloadProtocol {}
