//
//  HealthKitOngoingView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 22/11/22.
//

import SwiftUI
import Combine

struct HealthKitOngoingView: View {
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    
    @State var steps: Double = 0.0
    @State private var subscriptions: Set<AnyCancellable> = []
    
    @Binding var quickChallenge: QuickChallenge
    
    var body: some View {
        NavigationView {
            VStack {
                if steps == 0.0 {
                    Text("No data available")
                        .padding(.bottom, 48)
                    
                    Button(action: {
                        self.healthKitViewModel.requestAuthorization()
                            .sink(receiveCompletion: { _ in },
                                  receiveValue: { _ in () })
                            .store(in: &subscriptions)
                    }, label: {
                        Text("Request HealthKit Permission")
                    })
                }
                else {
                    Section("Step Count", content: {
                        Text("\(steps, specifier: "%.0f")")
                    })
                }
                
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        self.healthKitViewModel.getStepCount(since: self.quickChallenge.createdAtDate)
                            .sink(receiveCompletion: { _ in }, receiveValue: { steps in
                                print("steps in view: \(steps.doubleValue(for: .count()))")
                                self.steps = steps.doubleValue(for: .count())
                            })
                            .store(in: &subscriptions)
                    }, label: {
                        Text("Refresh")
                    })
                })
            })
            .navigationTitle("Health App")
        }
    }
}

struct HealthKitOngoingView_Previews: PreviewProvider {
    static var previews: some View {
        HealthKitOngoingView(quickChallenge: .constant(QuickChallenge(id: "", name: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))))
    }
}
