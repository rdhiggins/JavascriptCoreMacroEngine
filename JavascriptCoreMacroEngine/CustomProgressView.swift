//
// CustomProgressView.swift
// MIT License
//
// Copyright (c) 2016 Spazstik Software, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

@IBDesignable
class CustomProgressView: UIView {
    
    /// This property specifies the maximum number of rotations that the view
    /// supports
    @IBInspectable var numberRotations: CGFloat = 10.0 {
        didSet {
            arcLayer.path = circlePath().CGPath
        }
    }
    
    
    /// The amount of progress to show.  A complete rotation is indicated with a 1.
    /// Progress is not limited to values between 0 and 1.  Each complete rotation
    /// is an addition 1 added on.  Progress can not go below zero.
    @IBInspectable var progress: CGFloat = 0 {
        didSet {
            if progress < 0.0 {
                progress = 0.0
            } else if progress > numberRotations {
                progress = numberRotations
            }
            
            updateLayerProgress()
        }
    }


    /// This property contains the color of the progress indicator.
    @IBInspectable var color: UIColor? {
        didSet {
            arcLayer.strokeColor = color?.CGColor
            endLayer.fillColor = color?.CGColor
            startLayer.fillColor = color?.CGColor
        }
    }


    /// This property contains the width of the line to use
    /// on the property indicator.
    @IBInspectable var lineWidth: CGFloat = 1 {
        didSet {
            arcLayer.lineWidth = lineWidth
            endLayer.path = endCapPath().CGPath
            startLayer.path = endCapPath().CGPath
        }
    }

    
    /// This property controls the amount of inset the ring should have
    @IBInspectable var ringInset: CGFloat = 0.0 {
        didSet {
            startLayer.path = endCapPath().CGPath
            endLayer.path = endCapPath().CGPath
            arcLayer.path = circlePath().CGPath
        }
    }

    /// The radius of the end cap shadow is controlled through
    /// this property.
    @IBInspectable var shadowRadius: CGFloat = 10 {
        didSet {
            endLayer.shadowRadius = shadowRadius
        }
    }


    /// The shadow offset of the end cap is controller with this
    /// property.
    @IBInspectable var shadowOffset: CGSize = CGSizeZero {
        didSet {
            endLayer.shadowOffset = shadowOffset
        }
    }


    /// The shadow opacity of the end cap is controller with this
    /// property.
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            endLayer.shadowOpacity = shadowOpacity
        }
    }


    /// The color of the shadow on the end cap.
    @IBInspectable var shadowColor: UIColor? {
        didSet {
            endLayer.shadowColor = shadowColor?.CGColor
        }
    }


    /// This property contains the animation duration for
    /// one compete rotation.
    ///
    /// Note: Setting this property to too fast of a
    /// duration can lead to the end cap animation and the
    /// arc animation to get out of sync.
    @IBInspectable var rotationDuration: Float = 2.0
    
    
    /// This property specifies the animation delay
    @IBInspectable var animationDelay: CFTimeInterval = 0.25
    
    
    // private properties for the three layers that we use
    private let arcLayer = CAShapeLayer()
    private let endLayer = CAShapeLayer()
    private let startLayer = CAShapeLayer()


    // private properties used to store old angle value to
    // help with determining the animations
    private var oldAngle: CGFloat = 0

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Make sure the initial value is 0
        arcLayer.strokeEnd = 0.0
        
        setupShapeLayers()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Make sure the initial value is 0
        arcLayer.strokeEnd = 0.0
        
        setupShapeLayers()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rect = circleFrame()
        reframeLayers(rect)
    }

    
    /// A private method that is called to perform the actual steps in updating
    /// the progress indicators.
    private func updateLayerProgress() {
        let fromStroke = arcLayer.strokeEnd
        let toStroke = progress / numberRotations
        let fromAngle = oldAngle

        // Calcuate the rotation angle...
        let delta: CGFloat = CGFloat(M_PI * 2.0) * progress - oldAngle
        let toAngle = oldAngle + delta

        let rotate = CATransform3DRotate(endLayer.transform, delta, 0, 0, 1)

        // Make the new setting together
        arcLayer.strokeEnd = toStroke
        endLayer.transform = rotate

        // Set the animation for the pending actions
        endLayer.addAnimation(endCapAnimation(fromAngle, toAngle: toAngle), forKey: "transform.rotation.z")
        arcLayer.addAnimation(circleAnimation(fromStroke, toStroke: toStroke, fromAngle: fromAngle, toAngle: toAngle), forKey: "strokeEnd")

        // Save the angle for the next time...
        oldAngle = toAngle
    }
    
    
    /// A utility used to setup the shapeLayers on initialization.   Each layer
    /// is initialized with the correct properties and loaded into view's
    /// CALayer hierarchy.
    private func setupShapeLayers() {
        let frame = circleFrame()

        setupShapeLayer(startLayer, frame: frame)

        setupShapeLayer(arcLayer, frame: frame)
        arcLayer.lineWidth = lineWidth
        arcLayer.lineCap = kCALineCapRound
        
        setupShapeLayer(endLayer, frame: frame)
        endLayer.shadowColor = UIColor.blackColor().CGColor
        endLayer.shadowRadius = lineWidth
        endLayer.shadowOpacity = 0.6
        endLayer.shadowOffset = CGSizeMake(lineWidth, 0)
    }


    /// A utility method used to perform redundant setup steps for a CAShapeLayer.
    /// This method also adds the shape layer to the views layer.
    ///
    /// - parameter shapeLayer: A CAShapeLayer to initialize and add into the
    /// view's CALayer hiearchy
    /// - parameter frame: A CGRect that is the new frame to use
    private func setupShapeLayer(shapeLayer: CAShapeLayer, frame: CGRect) {
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = color?.CGColor

        layer.addSublayer(shapeLayer)
    }

    
    /// A utility called to update the CAShapeLayers when the view is laying
    /// out it's subviews.  Each layers frame property is updated and then
    /// a new CGPath is loaded into the layer.
    ///
    /// parameter frame: A CGRect that is the new frame to use for the views
    private func reframeLayers(frame: CGRect) {
        reframeLayer(startLayer, frame: frame)
        startLayer.path = endCapPath().CGPath

        reframeLayer(arcLayer, frame: frame)
        arcLayer.path = circlePath().CGPath

        reframeLayer(endLayer, frame: frame)
        endLayer.path = endCapPath().CGPath
    }

    
    /// A utility method used to properly update the frame for CAShapeLayer.
    private func reframeLayer(layer: CAShapeLayer, frame: CGRect) {
        layer.bounds = CGRect(origin: CGPointZero, size: frame.size)
        layer.position = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
    }

    
    /// A utility method that returns the frame to use for the shape layers that
    /// do all the work.  The frame is square with a width/height equal to
    /// one half the smallest dimension.
    ///
    /// - returns: A CGRect to use as the frame for a shape layer
    private func circleFrame() -> CGRect {
        let radius = min(bounds.width / 2, bounds.height / 2)
        let frame = CGRect(origin: CGPointMake(bounds.width / 2, bounds.height / 2), size: CGSizeZero)

        return CGRectInset(frame, -radius, -radius)
    }

    
    /// A utility method that returns the radius to use for the circle.  It
    /// assumes that the circle is being drawn with a stroke (no fill).  The
    /// circle is assumed to fill the entire views rect in the smallest
    /// direction.
    ///
    /// - returns: The radius to use.
    private func circleRadius() -> CGFloat {
        let rect = circleFrame()

        return min(rect.width, rect.height) / 2.0 - lineWidth - ringInset
    }

    
    /// A utility method that returns the center of the circle.  This assumes
    /// that the view is square.
    ///
    /// - returns: A CGPoint to use as the center point of the circle
    private func circleCenter() -> CGPoint {
        let radius = circleRadius() + lineWidth + ringInset
        return CGPointMake(radius, radius)
    }


    /// A method for generating a UIBezierPath for the arc layer
    ///
    /// - returns: A UIBezierPath that is a arc that uses the current
    /// radius, and lineWidth.
    private func circlePath() -> UIBezierPath {
        let topAngle: CGFloat = CGFloat(-M_PI_2)
        let endAngle: CGFloat = CGFloat(2 * M_PI) * numberRotations - CGFloat(M_PI_2)
        let path = UIBezierPath(arcCenter: circleCenter(), radius: circleRadius(), startAngle: topAngle, endAngle: endAngle, clockwise: true)
        
        return path
    }

    
    /// A method for generating a UIBezierPath for a end cap layer
    ///
    /// - returns: A UIBezierPath that is a end cap that uses the current
    /// radius, and lineWidth.
    private func endCapPath() -> UIBezierPath {
        let c = circleCenter()
        let capCenter = CGPointMake(c.x, c.y - circleRadius())

        var rect = CGRect(origin: capCenter, size: CGSizeZero)
        rect = CGRectInset(rect, -lineWidth / 2, -lineWidth / 2)
        
        return UIBezierPath(ovalInRect: rect)
    }
}




extension CustomProgressView {


    /// A private method used to generate the animation for the arc to show
    /// the main progress.  The angle values are used to derive the correct
    /// duration and begin time of the animation.
    ///
    /// - parameter fromStroke: The current value of the strokeEnd CAShapeLayer property
    /// - parameter toStroke: What new new setting of the strokeEnd CAShapeLayer property
    /// - parameter fromAngle: The starting angle in radians
    /// - parameter toAngle: The ending angle in radians.  Can be more then 2*pie in change.
    /// - return: A CABasicAnimation properly setup for the desired changes.
    private func circleAnimation(fromStroke: CGFloat, toStroke: CGFloat, fromAngle: CGFloat, toAngle: CGFloat) -> CABasicAnimation {
        let ba = CABasicAnimation(keyPath: "strokeEnd")
        ba.fromValue = fromStroke
        ba.toValue = toStroke
        ba.duration = angleRotationDuration(fromAngle, toAngle: toAngle)
        ba.beginTime = CACurrentMediaTime() + animationDelay
        ba.cumulative = false
        ba.removedOnCompletion = true
        ba.fillMode = kCAFillModeBackwards
        ba.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return ba
    }


    /// A private method used to generate the animation for the end cap that rotates
    /// through the desired number of rotations.
    ///
    /// - parameter fromAngle: The starting angle in radians
    /// - parameter toAngle: The ending angle in radians.  Can be more then 2*pie in change.
    /// - return: A CABasicAnimation properly setup for the desired changes.
    private func endCapAnimation(fromAngle: CGFloat, toAngle: CGFloat) -> CABasicAnimation {
        let ba = CABasicAnimation(keyPath: "transform.rotation.z")
        ba.fromValue = fromAngle
        ba.toValue = toAngle
        ba.duration = angleRotationDuration(fromAngle, toAngle: toAngle)
        ba.beginTime = CACurrentMediaTime() + animationDelay
        ba.cumulative = false
        ba.removedOnCompletion = true
        ba.fillMode = kCAFillModeBackwards
        ba.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return ba
    }


    /// A private method used to calculate the proper duration of the end cap
    /// animation.
    ///
    /// - parameter fromAngle: The starting angle in radians
    /// - parameter toAngle: The ending angle in radians.  Can be more then 2*pie in change.
    /// - return: The CFTimeInterval to be used for the animation
    private func angleRotationDuration(fromAngle: CGFloat, toAngle: CGFloat) -> CFTimeInterval {
        let deltaAngle = abs(toAngle - fromAngle)
        
        // Want to use a full rotation time for changes less then one rotation
        if deltaAngle < CGFloat(M_PI * 2) {
            return CFTimeInterval(rotationDuration)
        } else {
            let numberRotations = deltaAngle / CGFloat(2 * M_PI)
            let time = CGFloat(rotationDuration) * round(numberRotations)
            
            return CFTimeInterval(time)
        }
    }
    
}



