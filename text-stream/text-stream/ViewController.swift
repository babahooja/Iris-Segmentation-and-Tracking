//
//  ViewController.swift
//  text-stream
//
//  Created by Himanshu Ahuja on 18/09/18.
//  Copyright © 2018 Himanshu Ahuja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let containerView = UIView(frame: CGRect(x:0,y:0,width:440,height:600))
    var characterStream: [Character] = []
    let characterSet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var randomTime: Double = 0.0
    var testCounter: Int = 0
    var timer = Timer()
    let df = DateFormatter()
    let button = UIButton(type: .custom)
    
    
    @objc func timerUpdate(){
        print (testCounter, self.characterStream[testCounter], df.string(from: Date()))
        self.charDisplay.text = String(self.characterStream[testCounter])
        testCounter += 1
        if testCounter == self.characterStream.count {
            timer.invalidate()
            button.isEnabled = false
        }
        else{
            timer.invalidate()
            let randomTime = Double(Int.random(in: 15..<25)) * 0.1
            timer = Timer.scheduledTimer(timeInterval: randomTime, target: self, selector: #selector(ViewController.timerUpdate), userInfo: nil, repeats: false)
        }
    }
    @IBOutlet weak var charDisplay: UILabel!
    
    @objc func clickButton(button: UIButton) {
//        print(self.characterStream.remove(at: 0))
        print("Button Pressed!", df.string(from: Date()))
        
        
    }
    
    func initVariables(){
        df.dateFormat = "y-MM-dd H:m:ss.SSSS"
        button.frame = CGRect(x:130, y:500, width:100, height:100)
        //        button.layer.borderColor = UIColor.white as? CGColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 50
        //        button.setTitle("button", for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(ViewController.clickButton(button:)), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize button, data format
        initVariables()
        characterStream.removeAll()
        DispatchQueue.global(qos: .userInteractive).async {
            while(self.characterStream.count < 10){
                let randomInt = Int.random(in: 2..<26)
                if Int.random(in: 0..<6) < 4 {
                    print("Character Generated: ", self.characterSet[randomInt])
                    self.characterStream.append(self.characterSet[randomInt])
                }
                else{
                    self.characterStream.append("A")
                    self.characterStream.append("B")
                    print("Character Generated: A\n", "Character Generated: B")
                }
            }
            self.characterStream.append("✅")
            DispatchQueue.main.async {
                self.charDisplay.text = String(self.characterStream.remove(at: 0))
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.timerUpdate), userInfo: nil, repeats: false)
            } // end main GCD
        } // end global GCD
    } //end viewDidLoad
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

extension StringProtocol {
    
    var string: String { return String(self) }
    
    subscript(offset: Int) -> Element {
        return self[index(startIndex, offsetBy: offset)]
    }
    
    subscript(_ range: CountableRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: CountableClosedRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    
    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        return prefix(range.upperBound.advanced(by: 1))
    }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        return prefix(range.upperBound)
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        return suffix(Swift.max(0, count - range.lowerBound))
    }
}
extension Substring {
    var string: String { return String(self) }
}
