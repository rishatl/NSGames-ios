//
//  AdsTransition.swift
//  NSGames
//
//  Created by Rishat Latypov on 05.05.2022
//

import UIKit

// Animation on onbaordingScreen
enum AdsTransitionType {
    case presentation
    case dismissal
}

class AdsTransitionManager: NSObject {
    var transitionDuration: TimeInterval = 0.75
    var transitionType: AdsTransitionType = .presentation
    var oldFrame = CGRect.zero

    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        return visualEffectView
    }()

    lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    // MARK: - Private Methods
    private func addBackgroundViews(to containerView: UIView) {
        blurEffectView.frame = containerView.frame
        blurEffectView.alpha = 0.0
        containerView.addSubview(blurEffectView)

        dimmingView.frame = containerView.frame
        dimmingView.alpha = 0.0
        containerView.addSubview(dimmingView)
    }

    private func getCloneHomeCell(_ cell: HomeScreenCollectionViewCell) -> HomeScreenCollectionViewCell {
        let newCell = HomeScreenCollectionViewCell()
        guard let config = cell.configuration else { fatalError() }
        newCell.setData(configuration: config)
        return newCell
    }
}

extension AdsTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: .from) else { return }
        guard let toView = transitionContext.viewController(forKey: .to) else { return }
        guard let homeVC = transitionType == .presentation ?
                ((fromView as? UINavigationController)?.topViewController as? HomeScreenViewController) :
                ((toView as? UINavigationController)?.topViewController as? HomeScreenViewController) else { return }
        guard let homeCell = homeVC.selectedView else { return }
        oldFrame = homeCell.frame

        let containerView = transitionContext.containerView
        containerView.subviews.forEach({ $0.removeFromSuperview() })

        let cloneHomeCell = getCloneHomeCell(homeCell)

        let newFrame = homeVC.view.convert(homeVC.collectionView.frame, to: nil)
        cloneHomeCell.frame = homeCell.frame.offsetBy(dx: newFrame.origin.x + HomeScreenCellCollectionConstants.minimumLineSpacing, dy: newFrame.origin.y + HomeScreenCellCollectionConstants.minimumLineSpacing)
        cloneHomeCell.layoutSubviews()

        if transitionType == .presentation {
            addBackgroundViews(to: containerView)
            containerView.addSubview(cloneHomeCell)
            containerView.addSubview(toView.view)
            homeCell.isHidden = true
            toView.loadViewIfNeeded()
            toView.view.alpha = 0.0

            animate(homeCell: cloneHomeCell, containerView: containerView, toView: toView.view) {
                cloneHomeCell.removeFromSuperview()
                containerView.layoutIfNeeded()
                homeCell.isHidden = false
                transitionContext.completeTransition(true)
            }
        } else {
//            addBackgroundViews(to: containerView)
//            toView.view.frame = containerView.frame
//            fromView.view.frame = containerView.frame
//            containerView.addSubview(toView.view)
//            containerView.addSubview(fromView.view)
//            fromView.view.layoutSubviews()
//            toView.view.layoutSubviews()
//            toView.view.alpha = 0.5
//            animateBack(homeCell: cloneHomeCell, containerView: containerView, toView: toView.view, fromView: fromView.view) {
//                fromView.view.removeFromSuperview()
//                cloneHomeCell.removeFromSuperview()
//                containerView.layoutIfNeeded()
            homeCell.isHidden = false
            transitionContext.completeTransition(true)
//            }
        }
    }

    func animate(homeCell: HomeScreenCollectionViewCell, containerView: UIView, toView: UIView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: transitionDuration / 6, animations: {
            homeCell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            homeCell.imageView.layer.cornerRadius = 0
            homeCell.layoutSubviews()
            self.dimmingView.alpha = 0.1
            self.blurEffectView.alpha = 0.5
        }, completion: { _ in
            let scaleY = CGFloat(containerView.frame.height) / CGFloat(homeCell.frame.height)
            let scaleX = CGFloat(containerView.frame.width) / CGFloat(homeCell.frame.width)
            toView.transform = CGAffineTransform(scaleX: 1 / scaleX, y: 1 / scaleY)
            toView.frame.origin = homeCell.frame.origin

            UIView.animate(withDuration: self.transitionDuration * 5 / 6,
                           delay: 0, animations: {
                            homeCell.alpha = 0
                            homeCell.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                            homeCell.frame.origin = containerView.safeAreaLayoutGuide.layoutFrame.origin

                            toView.alpha = 1
                            toView.transform = .identity
                            toView.frame.origin = .zero
                           }, completion: { _ in
                            completion()
                           })
        })
    }

    func animateBack(homeCell: HomeScreenCollectionViewCell, containerView: UIView, toView: UIView, fromView: UIView, completion: @escaping () -> Void) {
        let scaleY = CGFloat(oldFrame.height) / CGFloat(containerView.frame.height)
        let scaleX = CGFloat(oldFrame.width) / CGFloat(containerView.frame.width)
        homeCell.alpha = 0
        homeCell.transform = CGAffineTransform(scaleX: CGFloat(1) / scaleX, y: CGFloat(1) / scaleY)
        homeCell.frame.origin = containerView.safeAreaLayoutGuide.layoutFrame.origin

        UIView.animate(withDuration: self.transitionDuration,
                       delay: 0, animations: {
                        toView.alpha = 1
                        homeCell.alpha = 1
                        fromView.alpha = 0
                        fromView.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                        homeCell.transform = .identity
                        fromView.frame.origin = self.oldFrame.origin
                       }, completion: { _ in
                        completion()
                       })
    }
}

extension AdsTransitionManager: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionType = .presentation
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionType = .dismissal
        return self
    }
}
