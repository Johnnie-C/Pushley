//
//  PushViewModel.swift
//  Pushley
//
//  Created by Johnnie Cheng on 6/3/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import UIKit

protocol PushViewModelProtocol {
    
    func test()
    
}

class PushViewModel: PushViewModelProtocol {

    func test() {
        print("test")
    }

}
