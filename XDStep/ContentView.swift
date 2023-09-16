//
//  ContentView.swift
//  XDStep
//
//  Created by Emre Cekic on 16.09.2023.
//

import CoreMotion
import SwiftUI

struct ContentView: View {
    
    @State var pedometerData = CMPedometer()
    @State var DATA = CMPedometerData()
    
    var body: some View {
        VStack {
            progressCircle()
            Text("\(DATA)")
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
    
    @State var stepCount = 0.0
    @State var stepGoal = 10000
    var percentage: Double {
        let o = stepGoal / 100
        return (stepCount * 100) / Double(o)
    }
    
    var body: some View {
        HStack {
            TextField("Step Goal", value: $stepGoal, format: .number)
        }
        ZStack {
            Circle()
                .stroke(lineWidth: 35)
                .foregroundColor(.orange)
                .opacity(0.1)
                .padding(50)
            Circle()
                .trim(from: 0.0, to: stepCount / Double(stepGoal))
                .stroke(style: StrokeStyle(lineWidth: 35, lineCap: .round, lineJoin: .round))
                .foregroundColor(.orange)
                .padding(50)
            Text("\(Int(stepCount)) STEPS")
        }
        Button("XXXXD", action: stepCountModifier)
    }
        
    func stepCountModifier() {
        stepCount += 1
    }
}
