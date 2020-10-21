//
//  ViewController.swift
//  DagoTracked-tvOS-Example
//
//  Created by Douwe Bos on 21/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import UIKit
import DagoTracked
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    
    let instanceBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.tracked
            .tap(UserEvent.Button.DidPressButton()) {
                print("User just pressed the button")
            }
            .disposed(by: instanceBag)
    }
}

protocol ExampleEvent: TrackedEvent where TrackedEventProperties == [String : Any] {}

extension ExampleEvent {
    func post() {
        print("Title: \(self.eventTitle) - Properties: \(self.eventProperties)")
    }
}

struct UserEvent {
    struct Button {
        struct DidPressButton: ExampleEvent {
            let eventTitle: String = "USER_DID_PRESS_TITLE"
            let eventProperties: [String : Any] = [:]
        }
    }
}
