//
//  PushViewRouter.swift
//  Pushley
//
//  Created by Johnnie Cheng on 29/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import SwiftUI

class PushViewRouter {

    static func newPushView() -> some View {
        return PushView(viewModel: PushViewModel())
    }
    
}
