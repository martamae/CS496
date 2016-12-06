//
//  RadioButton.swift
//  RSVP
//
//  Created by Marta Ochoa on 12/4/16.
//  Copyright © 2016 Marta Wegner. All rights reserved.
// source:http://stackoverflow.com/questions/29117759/how-to-create-radio-buttons-and-checkbox-in-swift-ios/29117898
//

import UIKit

class RadioButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var alternateButton:Array<RadioButton>?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = true
    }
    
    func unselectAlternateButtons(){
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:RadioButton in alternateButton! {
                aButton.isSelected = false
            }
        }
        else{
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton(){
        self.isSelected = !isSelected
    }
    
    var pink = UIColor(red: 162.0/255.0, green: 120.0/255.0, blue: 142.0/255.0, alpha: 1.0)
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = pink.cgColor
            } else {
                self.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }

}
