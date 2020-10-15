//
//  ViewController.swift
//  DagoConstrained
//
//  Created by douwebos on 10/15/2020.
//  Copyright (c) 2020 douwebos. All rights reserved.
//

import DagoConstrained

class ViewController: UIViewController {
    var animationView: UIView!
    
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
        
        animationView = UIView.with(parent: self.view) { animationView in
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
                
                dragView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.didDrag(recognizer:))))
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
                    
                    triggerButton.addTarget(self, action: #selector(self.animateView(sender:)), for: .touchUpInside)
                }
                
                UIButton.with(parent: buttonStackView) { triggerButton in
                    triggerButton.setTitle("OPEN", for: .normal)
                    triggerButton.backgroundColor = .green
                    
                    triggerButton.addTarget(self, action: #selector(self.openView(sender:)), for: .touchUpInside)
                }
                
                UIButton.with(parent: buttonStackView) { triggerButton in
                    triggerButton.setTitle("CLOSE", for: .normal)
                    triggerButton.backgroundColor = .blue
                    
                    triggerButton.addTarget(self, action: #selector(self.closeView(sender:)), for: .touchUpInside)
                }
            }
        }
    }
    
    @objc func animateView(sender: Any) {
        self.animationView.constrained.clear(constraint: .center)
        self.animationView.constrained.clear(constraint: .margin)
        
        let newTop = CGFloat.random(in: 0.0..<(self.view.frame.height - self.animationView.frame.height))
        let newLeading = CGFloat.random(in: 0.0..<(self.view.frame.width - self.animationView.frame.width))
        self.animationView.constrained.margin(
            top: newTop,
            leading: newLeading,
            safeArea: true
        )
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func openView(sender: Any) {
        self.animationView.constrained.clear(constraint: .margin)
        self.animationView.constrained.clear(constraint: .width)
        self.animationView.constrained.clear(constraint: .height)
        
        self.animationView.constrained.center()
        self.animationView.constrained.height(equals: self.view, multiplier: 0.8)
        self.animationView.constrained.width(equals: self.view, multiplier: 0.8)
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func closeView(sender: Any) {
        self.animationView.constrained.clear(constraint: .margin)
        self.animationView.constrained.clear(constraint: .center)
        self.animationView.constrained.clear(constraint: .width)
        self.animationView.constrained.clear(constraint: .height)
        
        self.animationView.constrained.height(equals: self.view, multiplier: 0.25)
        self.animationView.constrained.width(equals: self.view, multiplier: 0.25)
        
        let newTop = CGFloat.random(in: 0.0..<(self.view.frame.height - (self.view.frame.height * 0.25)))
        let newLeading = CGFloat.random(in: 0.0..<(self.view.frame.width - (self.view.frame.width * 0.25)))
        self.animationView.constrained.margin(
            top: newTop,
            leading: newLeading,
            safeArea: true
        )
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func didDrag(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        self.animationView.constrained.clear(constraint: .center)
        self.animationView.constrained.translate(top: translation.y, leading: translation.x, safeArea: true)
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended {
            let newTop = max(
                min(
                    self.animationView.frame.origin.y - self.view.safeAreaInsets.top,
                    self.view.frame.height - self.animationView.frame.height - self.view.safeAreaInsets.bottom
                ),
                self.view.safeAreaInsets.top
            )
            let newLeading = max(
                min(
                    self.animationView.frame.origin.x - self.view.safeAreaInsets.left,
                    self.view.frame.width - self.animationView.frame.width - self.view.safeAreaInsets.right
                ),
                self.view.safeAreaInsets.left
            )
            
            self.animationView.constrained.margin(
                top: newTop,
                leading: newLeading,
                safeArea: true
            )
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
