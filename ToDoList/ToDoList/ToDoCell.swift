//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Arin Asawa on 7/22/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import UIKit


protocol ToDoCellDelegate:class {
    func checkmarkTapped(sender:ToDoCell)
}

class ToDoCell: UITableViewCell {
    
    @IBOutlet var isCompleteButton:UIButton?
    @ IBOutlet var titleLabel:UILabel!
    weak var delegate: ToDoCellDelegate?
    
    
    @IBAction func completeButtonTapped(){
        self.delegate?.checkmarkTapped(sender: self)
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
