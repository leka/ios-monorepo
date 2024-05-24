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
                self?.activityCompletionDataListSubject.send(fetchedData)
            })
            .store(in: &self.cancellables)
    }

    public func saveActivityCompletionData(data: ActivityCompletionData) -> AnyPublisher<ActivityCompletionData, Error> {
        self.dbOps.create(data: data, in: .activityCompletionData)
            .flatMap { [weak self] completionData -> AnyPublisher<ActivityCompletionData, Error> in
                guard self != nil else {
                    return Fail(error: DatabaseError.customError("Unexpected Nil Value")).eraseToAnyPublisher()
                }

                return Just(completionData)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { _ in
                // Nothing to do
            })
            .eraseToAnyPublisher()
    }

    // MARK: Internal

    var activityCompletionDataList: AnyPublisher<[ActivityCompletionData], Never> {
        self.activityCompletionDataListSubject.eraseToAnyPublisher()
    }

    var fetchErrorPublisher: AnyPublisher<Error, Never> {
        self.fetchErrorSubject.eraseToAnyPublisher()
    }

    // MARK: Private

    private var activityCompletionDataListSubject = CurrentValueSubject<[ActivityCompletionData], Never>([])
    private var fetchErrorSubject = PassthroughSubject<Error, Never>()
    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()
}
