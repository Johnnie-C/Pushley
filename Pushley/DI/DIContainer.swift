//
//  DIContainer.swift
//  Pushley
//
//  Created by Johnnie Cheng on 28/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

//import Cocoa
//
//protocol Injectable {
//    
//    static func inject<T>(container: DIContainer) -> T
//    
//}
//
//class DIContainer: NSObject {
//
//    static let shared = DIContainer()
//    
//    func inject<T: Injectable>(_ T: T.Type) -> T {
//        return T.inject(container: self)
//    }
//
//    func injectAPNP12Networker() -> APNNetworkerProtocol {
//        return inject(APNP12Networker.self)
//    }
//    
//}
//
////MARK: - Interactor
//extension DIContainer {
//    
//    func injectPushNotificationInteractor() -> PushNotificationInteractorProtocol {
//        return inject(PushNotificationInteractor.self)
//    }
//    
//}
//
////MARK: - PushView
//extension DIContainer {
//    
//    func injectPushViewModel() -> some PushViewModelProtocol {
//        return inject(PushViewModel.self)
//    }
//    
//    func injectPushViewRouter() -> some PushViewRouterProtocol {
//        return inject(PushViewRouter.self)
//    }
//    
//}
