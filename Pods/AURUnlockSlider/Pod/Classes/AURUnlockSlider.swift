

import UIKit

@objc public protocol AURUnlockSliderDelegate: class {
    
    func unlockSliderDidUnlock(slider:AURUnlockSlider)
}

@objc public class AURUnlockSlider: UIView {
    
    final public weak var delegate:AURUnlockSliderDelegate?
    
    final public var sliderText = "Slide to Unlock"
    final public var sliderTextColor:UIColor = UIColor.lightGrayColor()
    final public var sliderTextFont:UIFont = UIFont(name: "HelveticaNeue-Thin", size: 15.0)!
    final public var sliderCornerRadius:CGFloat = 3.0
    final public var sliderColor = UIColor.clearColor()
    final public var sliderBackgroundColor:UIColor = UIColor.clearColor()
    
    final private let sliderContainer = UIView(frame: CGRectZero)
    final private let sliderView = UIView(frame: CGRectZero)
    final private let sliderViewLabel = UILabel(frame: CGRectZero)
    final private var isCurrentDraggingSlider = false
    final private var lastDelegateFireOffset = CGFloat(0)
    final private var touchesBeganPoint = CGPointZero
    final private var valueChangingTimer:NSTimer?
    final private let sliderPanGestureRecogniser = UIPanGestureRecognizer()
    final private let dynamicButtonAnimator = UIDynamicAnimator()
    final private var snappingBehavior:SliderSnappingBehavior?
    
    
    public override init(frame:CGRect) {
        
        super.init(frame: frame)
        
        
        setupView()
        setNeedsLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setupView()
        setNeedsLayout()
    }
    
    private func setupView() {
        
        sliderContainer.backgroundColor = backgroundColor
        
        sliderContainer.addSubview(sliderView)
        
        sliderViewLabel.userInteractionEnabled = false
        sliderViewLabel.textAlignment = NSTextAlignment.Center
        sliderViewLabel.textColor = sliderTextColor
        sliderView.addSubview(sliderViewLabel)
        
        sliderPanGestureRecogniser.addTarget(self, action: NSSelectorFromString("handleGesture:"))
        sliderView.addGestureRecognizer(sliderPanGestureRecogniser)
        
        sliderContainer.center = CGPointMake(bounds.size.width * 0.5, bounds.size.height * 0.5)
        addSubview(sliderContainer)
        clipsToBounds = true
    }
    
    override public func layoutSubviews() {
        
        super.layoutSubviews()
        
        sliderContainer.frame = frame
        sliderContainer.center = CGPointMake(bounds.size.width * 0.5, bounds.size.height * 0.5)
        sliderContainer.backgroundColor = sliderBackgroundColor
        
        sliderView.frame = CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)
        sliderView.center = CGPointMake(bounds.size.width * 0.5, bounds.size.height * 0.5)
        sliderView.backgroundColor = sliderColor
        
        sliderViewLabel.frame = CGRectMake(0.0, 0.0, sliderView.bounds.size.width, sliderView.bounds.size.height)
        sliderViewLabel.center = CGPointMake(sliderViewLabel.bounds.size.width * 0.5, sliderViewLabel.bounds.size.height * 0.5)
        sliderViewLabel.backgroundColor = sliderColor
        sliderViewLabel.font = sliderTextFont
        sliderViewLabel.text = sliderText
        
        layer.cornerRadius = sliderCornerRadius
    }
    
    final func handleGesture(sender: UIGestureRecognizer) {
        
        if sender as NSObject == sliderPanGestureRecogniser {
            
            switch sender.state {
                
            case .Began:
                isCurrentDraggingSlider = true
                touchesBeganPoint = sliderPanGestureRecogniser.translationInView(sliderView)
                if dynamicButtonAnimator.behaviors.count != 0 {
                    dynamicButtonAnimator.removeBehavior(snappingBehavior!)
                }
                
                lastDelegateFireOffset = ((touchesBeganPoint.x + touchesBeganPoint.x) * 0.40)
                
            case .Changed:
                valueChangingTimer?.invalidate()
                let translationInView = sliderPanGestureRecogniser.translationInView(sliderView)
                let translatedCenterX:CGFloat = (bounds.size.width * 0.5) + ((touchesBeganPoint.x + translationInView.x))
                sliderView.center = CGPointMake(translatedCenterX, sliderView.center.y);
                lastDelegateFireOffset = translatedCenterX
                
            case .Ended:
                
                fallthrough
                
            case .Failed:
                
                fallthrough
                
            case .Cancelled:
                var point: CGPoint?
                if sliderView.frame.origin.x > sliderContainer.center.x {
                    delegate?.unlockSliderDidUnlock(self)
                    point = CGPointMake(bounds.size.width * 1.5, bounds.size.height * 0.5)
                } else {
                    point = CGPointMake(bounds.size.width * 0.5, bounds.size.height * 0.5)
                }
                
                snappingBehavior = SliderSnappingBehavior(item: sliderView, snapToPoint: point!)
                lastDelegateFireOffset = sliderView.center.x
                dynamicButtonAnimator.addBehavior(snappingBehavior!)
                isCurrentDraggingSlider = false
                lastDelegateFireOffset = center.x
                valueChangingTimer?.invalidate()
                
            case .Possible:
                
                print("possible")
            }
        }
    }
}

final class SliderSnappingBehavior: UIDynamicBehavior {
    
    var snappingPoint:CGPoint
    init(item: UIDynamicItem, snapToPoint point: CGPoint) {
        
        let dynamicItemBehavior:UIDynamicItemBehavior  = UIDynamicItemBehavior(items: [item])
        dynamicItemBehavior.allowsRotation = false
        
        let snapBehavior:UISnapBehavior = UISnapBehavior(item: item, snapToPoint: point)
        snapBehavior.damping = 1
        
        snappingPoint = point
        
        super.init()
        
        addChildBehavior(snapBehavior)
        addChildBehavior(dynamicItemBehavior)
        
    }
    
    
}
