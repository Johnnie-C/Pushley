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
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, World!")
            }
            .navigationBarTitle(Text("Pushley"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            self.viewModel.test()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
    
}
