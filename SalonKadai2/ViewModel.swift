//
//  ViewModel.swift
//  SalonKadai2
//
//  Created by 坂本龍哉 on 2021/06/26.
//

import Foundation


final class ViewModel {
    let changeResultLabel = Notification.Name("changeResultLabel")
    
    private let notificationCenter: NotificationCenter
    private let model: ModelProtocol
    
    init(notificationCenter: NotificationCenter, model: ModelProtocol = Model()) {
        self.notificationCenter = notificationCenter
        self.model = model
    }
    
    func numberInputed(firstNumber: String?, secondNumber: String?, index: Int) {
        var state: CalculateState = .plus
        switch index {
        case 0: state = .plus
        case 1: state = .minus
        case 2: state = .multipliedBy
        case 3: state = .dividedBy
        default: break
        }

        let result = model.calculate(firstNumber: firstNumber, secondNumber: secondNumber, calculateStete: state)
        
        switch result {
        case .success(let result):
            notificationCenter.post(name: changeResultLabel, object: result)
        case .failure(let error as ModelError):
            notificationCenter.post(name: changeResultLabel, object: error.errorText)
        case _: fatalError("予想外")
        }
    }
}

extension ModelError {
    var errorText: String {
        switch self {
        case .invalidBothNumbers:
            return "未入力が２箇所あります"
        case .invalidFirstNumber:
            return "1つ目が未入力です"
        case .invalidSecondNumber:
            return "2つ目が未入力です"
        case .invalidDividedByZero:
            return "割る数には０以外の数字を入力してください"
        }
    }
}
