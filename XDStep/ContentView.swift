//
//  ContentView.swift
//  XDStep
//
//  Created by Emre Cekic on 16.09.2023.
//

import CoreMotion
import HealthKit
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            progressCircle()
        }
        
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct progressCircle: View {
    
    @State var stepGoal = 10000
    
    let healtStore = HKHealthStore()
    let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    
    @State var result = 0.0
    
    var body: some View {
        if result >= 10000 {
            Text("🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉")
        }
        ZStack {
            Circle()
                .stroke(lineWidth: 35)
                .foregroundColor(.orange)
                .opacity(0.1)
                .padding(50)
            Circle()
                .trim(from: 0.0, to: result / Double(stepGoal))
                .stroke(style: StrokeStyle(lineWidth: 35, lineCap: .round, lineJoin: .round))
                .foregroundColor(.orange)
                .padding(50)
            result < 10000 ? Text("\(Int(result)) STEPS") : Text("\(Int(result)) STEPS :O")
        }.onAppear(perform: stepCount)
            .onDisappear(perform: stepCount)
        Button("Reload Data", action: stepCount).buttonStyle(.bordered)
    }
    
    func stepCount() {
        let now = Date()
        let yesterday = Calendar.current.date(byAdding: .hour, value: 0, to: Date.now)
        
        var interval = DateComponents()
        interval.day = 1
        
        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: now)
            anchorComponents.hour = 0
        let anchorDate = Calendar.current.date(from: anchorComponents)!
        
        let query = HKStatisticsCollectionQuery(quantityType: stepQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval)
        
        
        query.initialResultsHandler = {
            _, results, error in
            guard let results = results else {return}
            
            results.enumerateStatistics(from: yesterday!, to: now) {
                data, error in
                if let sum = data.sumQuantity() {
                    let steps = sum.doubleValue(for: HKUnit.count())
                    result = steps
                }
            }
        }
        healtStore.execute(query)
    }
}
