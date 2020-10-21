//
//  ViewController.swift
//  DagoTracked
//
//  Created by douwebos on 10/21/2020.
//  Copyright (c) 2020 douwebos. All rights reserved.
//

import UIKit
import DagoTracked
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var `switch`: UISwitch!
    
    let instanceBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        button.tracked
            .tap(UserEvent.Button.DidPressButton()) {
                print("User just pressed the button")
            }
            .disposed(by: instanceBag)
        
        `switch`.tracked
            .value(skip: 1) { newValue in
                print("User just toggle the switch: \(newValue)")
            }
            event: { newValue in
                UserEvent.Switch.DidToggleSwitch(state: newValue)
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
    
    struct Switch {
        struct DidToggleSwitch: ExampleEvent {
            let eventTitle: String = "USER_DID_TOGGLE_SWITCH"
            var eventProperties: [String : Any] {
                get {
                    return ["state": state]
                }
            }
            
            let state: Bool
        }
    }
}
