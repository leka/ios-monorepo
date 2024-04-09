// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public class ActivityCompletionDataManager {
    // MARK: Lifecycle

    private init() {
        self.initializeActivityCompletionDataListener()
    }

    // MARK: Public

    public static let shared = ActivityCompletionDataManager()

    public func initializeActivityCompletionDataListener() {
        self.dbOps.observeAll(from: .activityCompletionData)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] fetchedData in
                self?.allRootOwnerActivityCompletionData.send(fetchedData)
            })
            .store(in: &self.cancellables)
    }

    public func fetchActivityCompletionData(CarereceiverID _: String) {
        // TODO: (@macteuts) fetch ActivityCompletionData for a specific profile (i.e. Carereceiver)
    }

//    public func saveActivityCompletionData(data: [ExerciseCompletionData]) -> AnyPublisher<[ExerciseCompletionData], Error> {
//        // TODO: (@macteuts) save ActivityCompletionData when an Activity completes
//    }

    // MARK: Internal

    var rootOwnerCompletionData: AnyPublisher<[ExerciseCompletionData], Never> {
        self.allRootOwnerActivityCompletionData.eraseToAnyPublisher()
    }

    var carereceiverCompletionData: AnyPublisher<[ExerciseCompletionData], Never> {
        self.activityCompletionDataPerCarereceiver.eraseToAnyPublisher()
    }

    var fetchErrorPublisher: AnyPublisher<Error, Never> {
        self.fetchErrorSubject.eraseToAnyPublisher()
    }

    // MARK: Private

    private var allRootOwnerActivityCompletionData = CurrentValueSubject<[ExerciseCompletionData], Never>([])
    private var activityCompletionDataPerCarereceiver = CurrentValueSubject<[ExerciseCompletionData], Never>([])
    private var fetchErrorSubject = PassthroughSubject<Error, Never>()
    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()
}
