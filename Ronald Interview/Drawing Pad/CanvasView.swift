//
//  CanvusView.swift
//  Ronald Interview
//
//  Created by Ronald Kwok on 1/4/2019.
//  Copyright © 2019 Ronald Kwok. All rights reserved.
//

import UIKit
import PureLayout

class CanvasView: UIView {
    
    private var bezierPath: UIBezierPath = UIBezierPath()
    private var preRenderImage: UIImage!
    
    private var controlPoints = [CGPoint]()
    private var drawingColor = UIColor.black
    
    private let drawingModeSegment: UISegmentedControl = {
        let segment = UISegmentedControl.newAutoLayout()
        
        segment.backgroundColor = UIColor.white
        segment.insertSegment(withTitle: "Normal", at: 0, animated: false)
        segment.insertSegment(withTitle: "Advance", at: 1, animated: false)
        segment.addTarget(self, action: #selector(changeMode), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        
        return segment
    }()

    private var advanceDrawingMode = false
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayer()
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupLayer()
        setupConstraints()
    }
    
    func setup() {
        initBezierPathValue()        
        self.backgroundColor = UIColor.white
    }
    
    // MARK: Setup Layer
    func setupLayer() {
        self.addSubview(drawingModeSegment)
    }
    
    // MARK: - Setup Constraints
    func setupConstraints() {
        drawingModeSegment.autoPinEdge(toSuperviewEdge: .left, withInset: 10.0)
        drawingModeSegment.autoPinEdge(.top, to: .top, of: self, withOffset: 100.0)
        drawingModeSegment.autoPinEdge(toSuperviewEdge: .right, withInset: 10.0)
        drawingModeSegment.autoSetDimension(.height, toSize: 30.0)
    }

    
    func initBezierPathValue() {
        bezierPath.lineWidth = 7
        bezierPath.lineCapStyle = CGLineCap.round
        bezierPath.lineJoinStyle = CGLineJoin.round
    }
    
    @objc func changeMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            advanceDrawingMode = true
            drawingColor = UIColor.red
        default:
            advanceDrawingMode = false
            drawingColor = UIColor.black
        }
    }
    
    func renderToImage() {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        if preRenderImage != nil {
            preRenderImage.draw(in: self.bounds)
        }
        
        drawingColor.setFill()
        drawingColor.setStroke()
        bezierPath.stroke()
        
        preRenderImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    @objc func clear() {
        preRenderImage = nil
        bezierPath.removeAllPoints()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawingColor.setFill()
        drawingColor.setStroke()
        if preRenderImage != nil {
            preRenderImage.draw(in: rect)
        }
        bezierPath.stroke()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchPoint = touch.location(in: self)
        
        controlPoints = []
        bezierPath.removeAllPoints()
        
        bezierPath.move(to: touchPoint)
        if(advanceDrawingMode){
            controlPoints.append(touchPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchPoint = touch.location(in: self)
        
        if(advanceDrawingMode){
            controlPoints.append(touchPoint)
            if(controlPoints.count == 5){
                
                controlPoints[3] = CGPoint(x: (controlPoints[2].x + controlPoints[4].x)/2.0,
                                           y: (controlPoints[2].y + controlPoints[4].y)/2.0)
                
                bezierPath.move(to: controlPoints[0])
                bezierPath.addCurve(to: controlPoints[3], controlPoint1: controlPoints[1], controlPoint2: controlPoints[2])
                setNeedsDisplay()
                
                var newControlPoints = [CGPoint]()
                
                newControlPoints.append(controlPoints[3])
                newControlPoints.append(controlPoints[4])
                
                controlPoints = newControlPoints
                
            }
        }else{
            bezierPath.addLine(to: touchPoint)
            bezierPath.move(to: touchPoint)
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(controlPoints.count < 5){
            switch controlPoints.count {
            case 1:
                bezierPath.addLine(to: controlPoints[0])
                break;
            case 2:
                bezierPath.move(to: controlPoints[0])
                bezierPath.addLine(to: controlPoints[1])
                break;
            case 3:
                bezierPath.move(to: controlPoints[0])
                bezierPath.addQuadCurve(to: controlPoints[2], controlPoint: controlPoints[1])
                break;
            case 4:
                bezierPath.addLine(to: controlPoints[0])
                bezierPath.addCurve(to: controlPoints[3], controlPoint1: controlPoints[1], controlPoint2: controlPoints[2])
                break;
            default:
                break;
            }
            
        }
        setNeedsDisplay()
        renderToImage()
        bezierPath.removeAllPoints()
    }
    
}
