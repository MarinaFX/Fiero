//
//  HealthStore+Extensions.swift
//  Fiero
//
//  Created by Marina De Pazzi on 22/11/22.
//

import Foundation
import HealthKit
import Combine

extension HKHealthStore {
    //TODO: discutir com marcelo e brenda sobre frequencia de necessidade de updates do healthkit
    func subject(for sampleType: HKQuantityType, since startDate: Date) -> AnyPublisher<HKQuantity, Error> {
        let subject = PassthroughSubject<HKQuantity, Error>()

        guard let stepsTaken = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            return Empty(completeImmediately: true, outputType: HKQuantity.self, failureType: Error.self).eraseToAnyPublisher()
        }

        let today = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: [])
                
        let query = HKStatisticsQuery(quantityType: stepsTaken, quantitySamplePredicate: today, options: .cumulativeSum) { (query, statisticsOrNil, errorOrNil) in
            guard let statistics = statisticsOrNil else {
                subject.send(completion: .finished)
                return
            }
            
            guard let stepCountOfToday = statistics.sumQuantity() else {
                subject.send(completion: .finished)
                return
            }
            subject.send(stepCountOfToday)
            subject.send(completion: .finished)
        }
        
        execute(query)
        return subject
            .eraseToAnyPublisher()
    }
}
