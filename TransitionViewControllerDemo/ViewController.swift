//
//  ViewController.swift
//  TransitionViewControllerDemo
//
//  Created by Hirose.Yudai on 2016/03/25.
//  Copyright © 2016年 Hirose.Yudai. All rights reserved.
//

import UIKit


class Animator: NSObject, UIViewControllerAnimatedTransitioning{
    
    private var operation: UINavigationControllerOperation
    
    init(_ operation: UINavigationControllerOperation) {
        self.operation = operation
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            containerView = transitionContext.containerView() else {
                fatalError()
        }
        
        let animations: Void -> Void
        let completion: Bool -> Void
        
        switch operation {
        case .Push:
            containerView.insertSubview(toView, aboveSubview: fromView)
            
            toView.frame.origin.x = UIScreen.mainScreen().bounds.size.width
            animations = {
                toView.frame.origin.x = 0
                fromView.frame.origin.x = -UIScreen.mainScreen().bounds.size.width * 0.4
            }
            completion = { completed in
                transitionContext.completeTransition(completed)
            }
        case .Pop:
            containerView.insertSubview(toView, belowSubview: fromView)
            animations = {
                fromView.frame.origin.x = UIScreen.mainScreen().bounds.size.width
                toView.frame.origin.x = 0
            }
            completion = { completed in
                transitionContext.completeTransition(completed)
            }
        default:
            fatalError()
        }
        
        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0,
            options: .CurveEaseInOut,
            animations: animations,
            completion: completion
        )
    }
}

class ViewController: UIViewController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
        return Animator(.Push)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! ToViewController
    }
}

class ToViewController: UIViewController, UINavigationControllerDelegate {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.delegate = self
    }
    
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
        return Animator(.Pop )
    }
}

