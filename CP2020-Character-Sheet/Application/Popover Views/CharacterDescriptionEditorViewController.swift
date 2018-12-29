//
//  CharacterDescriptionEditorViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/29/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class CharacterDescriptionEditorViewController: UIViewController {
    private let charaterDescriptionController: CharacterDescriptionController
    
    init(with characterDescriptionController: CharacterDescriptionController) {
        self.charaterDescriptionController = characterDescriptionController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}
