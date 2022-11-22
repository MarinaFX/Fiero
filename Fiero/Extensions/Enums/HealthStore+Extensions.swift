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
    func subject(for sampleType: HKQuantityType) -> AnyPublisher<HKQuantity, Error> {
        let subject = PassthroughSubject<HKQuantity, Error>()

        guard let stepsTaken = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            subject.send(completion: .finished)
            fatalError("*** Unable to get the step count type ***")
        }
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)

        guard let startDate = calendar.date(from: components) else {
            subject.send(completion: .finished)
            fatalError("*** Unable to create the start date ***")
        }
         
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            subject.send(completion: .finished)
            fatalError("*** Unable to create the end date ***")
        }

        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
                
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
