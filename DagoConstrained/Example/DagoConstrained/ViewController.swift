//
//  ViewController.swift
//  DagoConstrained
//
//  Created by douwebos on 10/15/2020.
//  Copyright (c) 2020 douwebos. All rights reserved.
//

import DagoConstrained
import RxSwift
import RxGesture

class ViewController: UIViewController {
    let instanceBag: DisposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        postInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        postInit()
    }
    
    func postInit() {
        self.view.backgroundColor = .white
        
        UIView.with(parent: self.view) { animationView in
            animationView.constrained.width(equals: self.view, multiplier: 0.25)
            animationView.constrained.height(equals: self.view, multiplier: 0.25)
            animationView.constrained.margin(top: 0.0, bottom: 0.0, safeArea: true)
            
            animationView.layer.cornerRadius = 8.0
            animationView.layer.masksToBounds = true
            
            let dragView = UIView.with(parent: animationView) { dragView in
                dragView.constrained.top()
                dragView.constrained.leading()
                dragView.constrained.trailing()
                
                dragView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                
                dragView.rx.panGesture()
                    .skip(1)
                    .subscribe(
                        onNext: { [weak self, weak animationView] recognizer in
                            guard let strongSelf = self,
                                  let strongAnimationView = animationView
                            else { return }
                            
                            let translation = recognizer.translation(in: strongSelf.view)
                            
                            ExampleEvents.AnimationView.DidDrag(
                                oldXCoordinate: strongAnimationView.frame.origin.x,
                                oldYCoordinate: strongAnimationView.frame.origin.y,
                                xCoordinate: strongAnimationView.frame.origin.x + translation.x,
                                yCoordinate: strongAnimationView.frame.origin.y + translation.y,
                                width: strongAnimationView.frame.width,
                                height: strongAnimationView.frame.height
                            ).post()
                            
                            strongAnimationView.constrained.clear(constraint: .center)
                            strongAnimationView.constrained.translate(top: translation.y, leading: translation.x, safeArea: true)
                            
                            recognizer.setTranslation(CGPoint.zero, in: strongSelf.view)
                            
                            if recognizer.state == .ended {
                                let newTop = max(
                                    min(
                                        strongAnimationView.frame.origin.y - strongSelf.view.safeAreaInsets.top,
                                        strongSelf.view.frame.height - strongAnimationView.frame.height - strongSelf.view.safeAreaInsets.bottom
                                    ),
                                    strongSelf.view.safeAreaInsets.top
                                )
                                let newLeading = max(
                                    min(
                                        strongAnimationView.frame.origin.x - strongSelf.view.safeAreaInsets.left,
                                        strongSelf.view.frame.width - strongAnimationView.frame.width - strongSelf.view.safeAreaInsets.right
                                    ),
                                    strongSelf.view.safeAreaInsets.left
                                )
                                
                                strongAnimationView.constrained.margin(
                                    top: newTop,
                                    leading: newLeading,
                                    safeArea: true
                                )
                                
                                UIView.animate(withDuration: 0.25) {
                                    strongSelf.view.layoutIfNeeded()
                                }
                            }
                        }
                    )
                    .disposed(by: self.instanceBag)
            }
            
            UIStackView.with(parent: animationView) { buttonStackView in
                buttonStackView.constrained.width()
                buttonStackView.constrained.bottom()
                buttonStackView.constrained.centerX()
                buttonStackView.constrained.height(equals: 40.0)
                buttonStackView.constrained.top(to: dragView.bottomAnchor)
                
                buttonStackView.distribution = .fillEqually
                
                UIButton.with(parent: buttonStackView) { triggerButton in
                    triggerButton.setTitle("ANIMATE", for: .normal)
                    triggerButton.backgroundColor = .red
                    
                    triggerButton.tracked.tap { [weak self, weak animationView] in
                        guard let strongSelf = self,
                              let strongAnimationView = animationView
                        else { return }
                        
                        strongAnimationView.constrained.clear(constraint: .center)
                        strongAnimationView.constrained.clear(constraint: .margin)
                        
                        let newTop = CGFloat.random(in: 0.0..<(strongSelf.view.frame.height - strongAnimationView.frame.height))
                        let newLeading = CGFloat.random(in: 0.0..<(strongSelf.view.frame.width - strongAnimationView.frame.width))
                        
                        strongAnimationView.constrained.margin(
                            top: newTop,
                            leading: newLeading,
                            safeArea: true
                        )
                        
                        UIView.animate(withDuration: 1.0) {
                            strongSelf.view.layoutIfNeeded()
                        }
                    }
                    event: { [weak animationView] in
                        return ExampleEvents.AnimationView.DidClickAnimate(
                            xCoordinate: animationView?.frame.origin.x ?? 0.0,
                            yCoordinate: animationView?.frame.origin.y ?? 0.0,
                            width: animationView?.frame.width ?? 0.0,
                            height: animationView?.frame.height ?? 0.0
                        )
                    }
                        .disposed(by: self.instanceBag)
                }
                
                UIButton.with(parent: buttonStackView) { triggerButton in
                    triggerButton.setTitle("OPEN", for: .normal)
                    triggerButton.backgroundColor = .green
                    
                    triggerButton.tracked.tap { [weak self, weak animationView] in
                        guard let strongSelf = self,
                              let strongAnimationView = animationView
                        else { return }
                        
                        strongAnimationView.constrained.clear(constraint: .margin)
                        strongAnimationView.constrained.clear(constraint: .width)
                        strongAnimationView.constrained.clear(constraint: .height)
                        
                        strongAnimationView.constrained.center()
                        strongAnimationView.constrained.height(equals: strongSelf.view, multiplier: 0.8)
                        strongAnimationView.constrained.width(equals: strongSelf.view, multiplier: 0.8)
                        
                        UIView.animate(withDuration: 1.0) {
                            strongSelf.view.layoutIfNeeded()
                        }
                    }
                    event: { [weak animationView] in
                        return ExampleEvents.AnimationView.DidClickOpen(
                            xCoordinate: animationView?.frame.origin.x ?? 0.0,
                            yCoordinate: animationView?.frame.origin.y ?? 0.0,
                            width: animationView?.frame.width ?? 0.0,
                            height: animationView?.frame.height ?? 0.0
                        )
                    }
                        .disposed(by: self.instanceBag)
                }
                
                UIButton.with(parent: buttonStackView) { triggerButton in
                    triggerButton.setTitle("CLOSE", for: .normal)
                    triggerButton.backgroundColor = .blue
                    
                    triggerButton.tracked.tap { [weak self, weak animationView] in
                        guard let strongSelf = self,
                              let strongAnimationView = animationView
                        else { return }
                        
                        strongAnimationView.constrained.clear(constraint: .margin)
                        strongAnimationView.constrained.clear(constraint: .center)
                        strongAnimationView.constrained.clear(constraint: .width)
                        strongAnimationView.constrained.clear(constraint: .height)
                        
                        strongAnimationView.constrained.height(equals: strongSelf.view, multiplier: 0.25)
                        strongAnimationView.constrained.width(equals: strongSelf.view, multiplier: 0.25)
                        
                        let newTop = CGFloat.random(in: 0.0..<(strongSelf.view.frame.height - (strongSelf.view.frame.height * 0.25)))
                        let newLeading = CGFloat.random(in: 0.0..<(strongSelf.view.frame.width - (strongSelf.view.frame.width * 0.25)))
                        
                        strongAnimationView.constrained.margin(
                            top: newTop,
                            leading: newLeading,
                            safeArea: true
                        )
                        
                        UIView.animate(withDuration: 1.0) {
                            strongSelf.view.layoutIfNeeded()
                        }
                    }
                    event: { [weak animationView] in
                        return ExampleEvents.AnimationView.DidClickClose(
                            xCoordinate: animationView?.frame.origin.x ?? 0.0,
                            yCoordinate: animationView?.frame.origin.y ?? 0.0,
                            width: animationView?.frame.width ?? 0.0,
                            height: animationView?.frame.height ?? 0.0
                        )
                    }
                        .disposed(by: self.instanceBag)
                }
            }
        }
    }
}
