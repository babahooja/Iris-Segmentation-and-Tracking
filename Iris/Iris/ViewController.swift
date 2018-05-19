//
//  ViewController.swift
//  Iris
//
//  Created by Himanshu Ahuja on 19/05/18.
//  Copyright © 2018 Himanshu Ahuja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var frameExtractor: FrameExtractor!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		frameExtractor = FrameExtractor()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

