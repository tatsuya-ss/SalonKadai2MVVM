//
//  ViewController.swift
//  SalonKadai2
//
//  Created by 坂本龍哉 on 2021/06/26.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var firstNumberTextField: UITextField!
    @IBOutlet private weak var secondNumberTextField: UITextField!
    @IBOutlet private weak var fourArithmeticOperationsSecmentedControl: UISegmentedControl!
    @IBOutlet private weak var resultLabel: UILabel!
    
    private let notificationCenter = NotificationCenter()
    private var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNumberTextField.keyboardType = .numberPad
        secondNumberTextField.keyboardType = .numberPad
        viewModel = ViewModel(notificationCenter: notificationCenter)
        
        firstNumberTextField.addTarget(self,
                                       action: #selector(textFieldEditingDidEnd),
                                       for: .editingChanged)
        secondNumberTextField.addTarget(self,
                                       action: #selector(textFieldEditingDidEnd),
                                       for: .editingChanged)
        fourArithmeticOperationsSecmentedControl.addTarget(self,
                                       action: #selector(textFieldEditingDidEnd),
                                       for: .valueChanged)

        notificationCenter.addObserver(self,
                                       selector: #selector(updateResultLabel),
                                       name: viewModel?.changeResultLabel,
                                       object: nil)
        
    }
}

extension ViewController {
    @objc func textFieldEditingDidEnd(sender: UITextField) {
        let index = fourArithmeticOperationsSecmentedControl.selectedSegmentIndex
        viewModel?.numberInputed(firstNumber: firstNumberTextField.text, secondNumber: secondNumberTextField.text, index: index)
        
    }
    
    @objc func updateResultLabel(notification: Notification) {
        guard let text = notification.object as? String else { return }
        resultLabel.text = text
    }
}

