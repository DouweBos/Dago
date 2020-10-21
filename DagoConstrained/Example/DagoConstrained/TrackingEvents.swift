//
//  TrackingEvents.swift
//  DagoConstrained_Example
//
//  Created by Douwe Bos on 21/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import DagoConstrained
import DagoTracked

protocol ExampleEvent: TrackedEvent where TrackedEventProperties == [String : Any] {}

extension ExampleEvent {
    func post() {
        print("Title: \(self.eventTitle) - Properties: \(self.eventProperties)")
    }
}

struct ExampleEvents {
    struct AnimationView {
        struct DidClickAnimate: ExampleEvent {
            let eventTitle: String = "ANIMATION_VIEW_DID_CLICK_ANIMATE"
            
            let xCoordinate: CGFloat
            let yCoordinate: CGFloat
            
            let width: CGFloat
            let height: CGFloat
            
            var eventProperties: [String : Any] {
                get {
                    return [
                        "x_coordinate": xCoordinate,
                        "y_coordinate": yCoordinate,
                        "width": width,
                        "height": height
                    ]
                }
            }
        }
        
        struct DidClickOpen: ExampleEvent {
            let eventTitle: String = "ANIMATION_VIEW_DID_CLICK_OPEN"
            
            let xCoordinate: CGFloat
            let yCoordinate: CGFloat
            
            let width: CGFloat
            let height: CGFloat
            
            var eventProperties: [String : Any] {
                get {
                    return [
                        "x_coordinate": xCoordinate,
                        "y_coordinate": yCoordinate,
                        "width": width,
                        "height": height
                    ]
                }
            }
        }
        
        struct DidClickClose: ExampleEvent {
            let eventTitle: String = "ANIMATION_VIEW_DID_CLICK_CLOSE"
            
            let xCoordinate: CGFloat
            let yCoordinate: CGFloat
            
            let width: CGFloat
            let height: CGFloat
            
            var eventProperties: [String : Any] {
                get {
                    return [
                        "x_coordinate": xCoordinate,
                        "y_coordinate": yCoordinate,
                        "width": width,
                        "height": height
                    ]
                }
            }
        }
        
        struct DidDrag: ExampleEvent {
            let eventTitle: String = "ANIMATION_VIEW_DID_DRAG"
            
            let oldXCoordinate: CGFloat
            let oldYCoordinate: CGFloat
            
            let xCoordinate: CGFloat
            let yCoordinate: CGFloat
            
            let width: CGFloat
            let height: CGFloat
            
            var eventProperties: [String : Any] {
                get {
                    return [
                        "old_x_coordinate": oldXCoordinate,
                        "old_y_coordinate": oldYCoordinate,
                        "x_coordinate": xCoordinate,
                        "y_coordinate": yCoordinate,
                        "width": width,
                        "height": height
                    ]
                }
            }
        }
    }
}

