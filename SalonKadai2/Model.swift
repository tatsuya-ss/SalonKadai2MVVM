//
//  Model.swift
//  SalonKadai2
//
//  Created by 坂本龍哉 on 2021/06/26.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum ModelError: Error {
    case invalidFirstNumber
    case invalidSecondNumber
    case invalidBothNumbers
    case invalidDividedByZero
}

enum CalculateState {
    case plus, minus, multipliedBy, dividedBy
    
    func calculate(first: Int, second: Int) -> Int {
        switch self {
        case .plus:
            return first + second
        case .minus:
            return first - second
        case .multipliedBy:
            return first * second
        case .dividedBy:
            return first / second
        }
    }
}

protocol ModelProtocol {
    func calculate(firstNumber: String?, secondNumber: String?, calculateStete: CalculateState) -> Result<String>
}



final class Model: ModelProtocol {
    func calculate(firstNumber: String?, secondNumber: String?, calculateStete: CalculateState) -> Result<String> {
        switch (firstNumber, secondNumber) {
        case (.none, .none):
            return .failure(ModelError.invalidBothNumbers)
        case (.none, .some):
            return .failure(ModelError.invalidFirstNumber)
        case (.some, .none):
            return .failure(ModelError.invalidSecondNumber)
        case (let firstNumber?, let secondNumber?):
            switch (firstNumber.isEmpty, secondNumber.isEmpty) {
            case (true, true):
                return .failure(ModelError.invalidBothNumbers)
            case (false, false):
                let first = Int(firstNumber) ?? 0
                let second = Int(secondNumber) ?? 0
                if case .dividedBy = calculateStete, second == 0 { return .failure(ModelError.invalidDividedByZero) }
                let result = calculateStete.calculate(first: first, second: second)
                let stringResult = String(result)
                return .success(stringResult)
            case (false, true):
                return .failure(ModelError.invalidSecondNumber)
            case (true, false):
                return .failure(ModelError.invalidFirstNumber)
            }
        }
    }
    
    
}
