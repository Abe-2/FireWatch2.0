//
//  ShelterView.swift
//  FireWatch2.0
//
//  Created by Abdalwahab on 10/18/19.
//  Copyright © 2019 team. All rights reserved.
//

import UIKit

class ShelterView: UIView {

    @IBOutlet var contentView: UIView!
    
    var route: (() -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ShelterView", owner: self, options: nil)
        contentView.frame.size.width = frame.size.width
        addSubview(contentView)
    }
    
    @IBAction func callRoute() {
        route()
    }

}
