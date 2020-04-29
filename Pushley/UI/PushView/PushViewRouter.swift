//
//  PushViewRouter.swift
//  Pushley
//
//  Created by Johnnie Cheng on 29/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import SwiftUI

protocol PushViewRouterProtocol {
    
}

class PushViewRouter: PushViewRouterProtocol {

    static func newPushView() -> some View {
        let viewModel = DIContainer.shared.injectPushViewModel()
        return PushView(viewModel: viewModel)
    }
    
}

extension PushViewRouter: Injectable {
    
    static func inject<T>(container: DIContainer) -> T {
        return PushViewRouter() as! T
    }
    
    
}
