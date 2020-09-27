//
//  CircleProgressBarView.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/12/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit
import RealmSwift

class CircleProgressBarView: UIView {
    let defaults = UserDefaults(suiteName: "group.com.Tonnelier.Lofee")
    let realm = try! Realm()
    var allSets: Results<Set>?
    
    private var backgroundLayer: CAShapeLayer!
    private var foregroundLayer: CAShapeLayer!
    private var textLayer: CATextLayer!
    private var gradientLayer: CAGradientLayer!
    
    var colorOneArray: [CGColor] = [#colorLiteral(red: 1, green: 0.526314795, blue: 0.1449918449, alpha: 1),#colorLiteral(red: 0.1013454869, green: 0.3797401786, blue: 0.5998533368, alpha: 1), #colorLiteral(red: 1, green: 0.8252188563, blue: 0.07557215542, alpha: 1), #colorLiteral(red: 0.3157519698, green: 0.5712475777, blue: 0.9614300132, alpha: 1)]
    var colorTwoArray: [CGColor] = [#colorLiteral(red: 0.9952645898, green: 0.1974133253, blue: 0.004842903931, alpha: 1), #colorLiteral(red: 0.006879793014, green: 0.09248053282, blue: 0.2674127817, alpha: 1), #colorLiteral(red: 1, green: 0.5465783477, blue: 0.0377869457, alpha: 1), #colorLiteral(red: 0.07942930609, green: 0.3270714879, blue: 0.6887398362, alpha: 1)]
    var colorNumber: Int!
    
    public var progress: CGFloat = 0{
        didSet{
            didProgressUpdated()
        }
    }
    func reload(){
        self.didProgressUpdated()
    }
    
    override func draw(_ rect: CGRect) {
        allSets = realm.objects(Set.self)

        let width = rect.width
        let height = rect.height
        
        let lineWidth = 0.1 * min(width, height)
        let center = CGPoint (x: width/2, y: height/2)
        let radius = (min(width, height) - lineWidth) / 2
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        backgroundLayer = CAShapeLayer()
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = #colorLiteral(red: 0.8703940511, green: 0.8700456023, blue: 0.9031139612, alpha: 1)
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = .round
        
        foregroundLayer = CAShapeLayer()
        foregroundLayer.path = circularPath.cgPath
        foregroundLayer.strokeColor = UIColor.red.cgColor
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.lineCap = .round
        
        foregroundLayer.strokeEnd = 0.0 //THIS DETERMINES HOW MUCH OF THE CIRCLE IS TAKEN UP
        if let count =  defaults?.integer(forKey: "setToStudyCount"){
            if let selectedSet = defaults?.object(forKey: "questionArray"){
                let set:[String] = selectedSet as! [String]
                foregroundLayer.strokeEnd = CGFloat((Double(count - set.count))/(Double(count)))
            }
        }
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x:1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        if (defaults?.object(forKey: "setPickedToBeStudied") != nil){
                  if let count = self.allSets?.count{
                      for index in 0..<count{
                          if (self.allSets![index].name) == (self.defaults?.object(forKey: "setPickedToBeStudied") as! String){
                             colorNumber = allSets![index].colorNumber
        
                          }
                      }
                  }
              }
        if colorNumber != nil{
            gradientLayer.colors = [colorOneArray[colorNumber], colorTwoArray[colorNumber]] //CHANGE COLORS OF GRADIENT HERE
        }
        gradientLayer.frame = rect
        gradientLayer.mask = foregroundLayer
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(gradientLayer)
        
    }
    private func didProgressUpdated(){
        textLayer?.string = "\(Int(progress*100))"
        foregroundLayer?.strokeEnd = progress
    }
}

