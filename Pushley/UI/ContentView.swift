//
//  ContentView.swift
//  Pushley
//
//  Created by Johnnie Cheng on 6/3/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    private let viewModel: PushViewModelProtocol = PushViewModel()
    
    var strengths = ["Mild", "Medium", "Mature"]

    @State private var selectedStrength = 0
    
    var body: some View {
        VStack {
            Picker(selection: $selectedStrength, label: Text("Strength")) {
                ForEach(0 ..< strengths.count) {
                    Text(self.strengths[$0])
                }
            }
        }
        .frame(minWidth: 500, maxWidth: .infinity,
               minHeight: 400, maxHeight: .infinity)
        .onAppear() {
//            self.viewModel.test()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
    
}
