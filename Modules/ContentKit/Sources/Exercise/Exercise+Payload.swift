// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - ExercisePayloadProtocol

public protocol ExercisePayloadProtocol: Codable {}

// MARK: - TouchToSelect.Payload + ExercisePayloadProtocol

extension TouchToSelect.Payload: ExercisePayloadProtocol {}

// MARK: - SuperSimon.Payload + ExercisePayloadProtocol

extension SuperSimon.Payload: ExercisePayloadProtocol {}

// MARK: - DragAndDropIntoZones.Payload + ExercisePayloadProtocol

extension DragAndDropIntoZones.Payload: ExercisePayloadProtocol {}

// MARK: - DragAndDropToAssociate.Payload + ExercisePayloadProtocol

extension DragAndDropToAssociate.Payload: ExercisePayloadProtocol {}

// MARK: - DragAndDropInOrder.Payload + ExercisePayloadProtocol

extension DragAndDropInOrder.Payload: ExercisePayloadProtocol {}

// MARK: - MidiRecordingPlayer.Payload + ExercisePayloadProtocol

extension MidiRecordingPlayer.Payload: ExercisePayloadProtocol {}

// MARK: - MusicalInstrument.Payload + ExercisePayloadProtocol

extension MusicalInstrument.Payload: ExercisePayloadProtocol {}

// MARK: - DanceFreeze.Payload + ExercisePayloadProtocol

extension DanceFreeze.Payload: ExercisePayloadProtocol {}

// MARK: - Memory.Payload + ExercisePayloadProtocol

extension Memory.Payload: ExercisePayloadProtocol {}
