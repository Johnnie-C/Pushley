//
//  ContentView.swift
//  Pushley
//
//  Created by Johnnie Cheng on 6/3/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = PushViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("Certificate: ")
                if viewModel.certificate != nil {
                    Text(viewModel.certificate!.label)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0), lineWidth: 1)
                    )
                }
                Button(
                    action:{ self.viewModel.showCertificatePicker() },
                    label: { Text("Select...") }
                )
                Spacer()
            }
            
            
            
            Spacer()
        }
        .padding(10)
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
