//
//  HealthKitViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 22/11/22.
//

import Foundation
import Combine
import HealthKit

class HealthKitViewModel: ObservableObject {
    private let healthStore: HKHealthStore = HKHealthStore()
    private let healthTypes: Set<HKSampleType> = Set([HKSampleType.quantityType(forIdentifier: .stepCount)!])

    @discardableResult
    func requestAuthorization() -> AnyPublisher<Bool, Error> {
        Future { [unowned self] promise in
            
            guard HKHealthStore.isHealthDataAvailable() else {
                promise(.failure(HealthDataError.unavailableOnDevice))
                return
            }
            
            self.healthStore.requestAuthorization(toShare: healthTypes, read: healthTypes) { authSuccess, error in
                guard error == nil else {
                    print("HealthKit authorization error:", error!.localizedDescription)
                    
                    promise(.failure(HealthDataError.authorizationRequestError))
                    return
                }
                
                if authSuccess {
                    promise(.success(true))
                } else {
                    promise(.failure(HealthDataError.authorizationRequestError))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getStepCount(since startDate: Date) -> AnyPublisher<HKQuantity, Error> {
        self.healthStore.subject(for: HKQuantityType.quantityType(forIdentifier: .stepCount)!, since: startDate)
            .eraseToAnyPublisher()
    }
}
