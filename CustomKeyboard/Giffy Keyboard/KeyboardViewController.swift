//
//  KeyboardViewController.swift
//  Nisha Keyboard
//
//  Created by Nisha  on 01/11/18.
//  Copyright © 2018 Nisha . All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet weak var charSet1: UIView!
    @IBOutlet weak var charSet2: UIView!
    @IBOutlet var alphabetsButtonCollection: [UIButton]!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gifSearchTextField: UITextField!

    var capsLockOn = true
    let defaultKeyboardHeight: CGFloat = 219
    var isShowingGif = false
    var isShowingFirstCharSet = true

    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        guard let keyboardView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else { return }
        keyboardView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: defaultKeyboardHeight)
        keyboardView.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height - defaultKeyboardHeight)
        view = keyboardView

        charSet2.isHidden = true
    }

    @IBAction func keyPressed(_ button: UIButton) {
        guard let string = button.titleLabel?.text else {return}
        (textDocumentProxy as UIKeyInput).insertText("\(string)")
        UIView.animate(withDuration: 0.2, animations: {
            button.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
        }, completion: {(_) -> Void in
            button.transform =
                CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        })
    }

    @IBAction func backSpacePressed(_ button: UIButton) {
        (textDocumentProxy as UIKeyInput).deleteBackward()
    }

    @IBAction func spacePressed(_ button: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText(" ")
    }

    @IBAction func returnPressed(_ button: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText("\n")
    }

    @IBAction func charSetPressed(_ button: UIButton) {
        isShowingFirstCharSet = !isShowingFirstCharSet
        charSet1.isHidden = !isShowingFirstCharSet
        charSet2.isHidden = isShowingFirstCharSet
        button.setTitle(isShowingFirstCharSet ? "2/2": "1/2", for: .normal)
    }

    @IBAction func capsLockPressed(_ sender: UIButton) {
        capsLockOn = !capsLockOn

        for button in alphabetsButtonCollection {
            let buttonTitle = button.titleLabel?.text
            button.setTitle(capsLockOn ? buttonTitle?.uppercased(): buttonTitle?.lowercased(), for: .normal)
        }
    }

    @IBAction func nextKeyboardPressed(_ button: UIButton) {
        advanceToNextInputMode()
    }

    @IBAction func gifButtonPressed(_ sender: UIButton) {
        isShowingGif = !isShowingGif
        imagesViewHeightConstraint.constant = isShowingGif ? 300: 0
        searchViewHeightConstraint.constant = isShowingGif ? 40: 0
        view.setNeedsLayout()
        view.setNeedsDisplay()
    }

    @IBAction func searchGif(_ sender: UIButton) {
    }
}
