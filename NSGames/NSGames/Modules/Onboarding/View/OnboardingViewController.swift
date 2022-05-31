//
//  OnboardingViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 26.04.2022
//

// swiftlint:disable all

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {

    // MARK: - UI
    let backgroundImageView: UIImageView = {
        let point = CGPoint(x: (UIScreen.main.bounds.width - ConstantSize.backgroundWidth()) / 2,
                            y: (UIScreen.main.bounds.height - ConstantSize.backgroundWidth()) / 2)

        let size = CGSize(width: ConstantSize.backgroundWidth(),
                          height: ConstantSize.backgroundWidth())

        let imageView = UIImageView(frame: CGRect(origin: point,
                                                  size: size))
        imageView.image = Asset.onboardingBackground.image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var leftStickImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: -ConstantSize.stickSize().width,
                                                                  y: ConstantSize.stickSize().height / 2.2 + backgroundImageView.frame.origin.y + 0.21 * ConstantSize.backgroundWidth()),
                                                  size: ConstantSize.stickSize()))
        imageView.image = Asset.vector1.image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var rightStickImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.width + ConstantSize.stickSize().width,
                                                                  y: ConstantSize.stickSize().height / 2.2 + backgroundImageView.frame.origin.y + 0.35 * ConstantSize.backgroundWidth()),
                                                  size: ConstantSize.stickSize()))
        imageView.image = Asset.vector.image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Properties
    var coordinator: OnboardingCoordinatorProtocol?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        startAnimation()
    }

    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(leftStickImageView)
        view.addSubview(rightStickImageView)
    }

    private func startAnimation() {
        backgroundImageView.layer.add(alphaAnimation(1), forKey: nil)
        sticksFirstAnimation()
    }

    private func sticksFirstAnimation() {
        let leftNewPoint = CGPoint(x: ConstantSize.stickSize().width / 2.5 + backgroundImageView.frame.origin.x + 0.1 * ConstantSize.backgroundWidth() + 12,
                                   y: ConstantSize.stickSize().height / 2.2 + backgroundImageView.frame.origin.y + 0.21 * ConstantSize.backgroundWidth())
//        let leftPointAnimation = moveAnimation(fromPoint: leftStickImageView.center, toPoint: leftNewPoint)

        let rightNewPoint = CGPoint(x: ConstantSize.stickSize().width / 2.3 + backgroundImageView.frame.origin.x + 0.55 * ConstantSize.backgroundWidth() - 12,
                                    y: ConstantSize.stickSize().height / 2.2 + backgroundImageView.frame.origin.y + 0.35 * ConstantSize.backgroundWidth())
//        let rightPointAnimation = moveAnimation(fromPoint: rightStickImageView.center, toPoint: rightNewPoint)

//        CATransaction.begin()
//        CATransaction.setCompletionBlock { [unowned self, leftNewPoint, rightNewPoint] in
//            self.leftStickImageView.layer.position = leftNewPoint
//            self.rightStickImageView.layer.position = rightNewPoint
//            self.sticksSecondAnimation()
//        }
//        leftStickImageView.layer.add(leftPointAnimation, forKey: nil)
//        rightStickImageView.layer.add(rightPointAnimation, forKey: nil)

        leftStickImageView.layer.add(alphaAnimation(0.6), forKey: nil)
        rightStickImageView.layer.add(alphaAnimation(0.6), forKey: nil)
        UIView.animate(withDuration: 0.85,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 12,
                       options: [.curveEaseOut],
                       animations: {
                        self.leftStickImageView.center = leftNewPoint
                        self.rightStickImageView.center = rightNewPoint
                       })

        let leftNewPoint2 = CGPoint(x: ConstantSize.stickSize().width / 2.5 + backgroundImageView.frame.origin.x + 0.1 * ConstantSize.backgroundWidth(),
                                    y: ConstantSize.stickSize().height / 2.2 + backgroundImageView.frame.origin.y + 0.21 * ConstantSize.backgroundWidth())
        let rightNewPoint2 = CGPoint(x: ConstantSize.stickSize().width / 2.3 + backgroundImageView.frame.origin.x + 0.55 * ConstantSize.backgroundWidth(),
                                     y: ConstantSize.stickSize().height / 2.2 + backgroundImageView.frame.origin.y + 0.35 * ConstantSize.backgroundWidth())

        UIView.animate(withDuration: 0.5,
                       delay: 0.7,
                       usingSpringWithDamping: 0.95,
                       initialSpringVelocity: 5,
                       options: [.curveEaseOut]) { [weak self] in
            self?.leftStickImageView.transform = CGAffineTransform(rotationAngle: CGFloat(ConstantSize.angleForLeft))
            self?.rightStickImageView.transform = CGAffineTransform(rotationAngle: CGFloat(ConstantSize.angleForRight))
            self?.leftStickImageView.center = leftNewPoint2
            self?.rightStickImageView.center = rightNewPoint2
        } completion: { [weak self] _ in
            self?.coordinator?.animationFinished()
        }
//        CATransaction.commit()
    }

    private func moveAnimation(fromPoint: CGPoint, toPoint: CGPoint) -> CABasicAnimation {
        let moveAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        moveAnimation.toValue = toPoint
        moveAnimation.duration = 0.85
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        return moveAnimation
    }

    private func alphaAnimation(_ duration: CFTimeInterval) -> CABasicAnimation {
        let alphaAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        alphaAnimation.toValue = 1
        alphaAnimation.fromValue = 0.2
        alphaAnimation.duration = duration
        return alphaAnimation
    }
}

extension OnboardingViewController {
    private enum ConstantSize {
        static let stickSize = { CGSize(width: backgroundWidth() * 0.45, height: backgroundWidth() * 0.6) }
        static let backgroundWidth = { UIScreen.main.bounds.width / 1.7 }
        static let angleForLeft = -Double.pi * 0.11
        static let angleForRight = Double.pi * 0.11
    }
}
