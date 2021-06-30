//
//  SalonKadai2Tests.swift
//  SalonKadai2Tests
//
//  Created by 坂本龍哉 on 2021/06/26.
//
import UIKit
import XCTest
@testable import SalonKadai2

class FakeModel : ModelProtocol {
    var result: Result<String>?
    
    func calculate(firstNumber: String?, secondNumber: String?, calculateStete: CalculateState) -> Result<String> {
        guard let result = result else {
            fatalError("validationResult has not been set.")
        }
        
        return result
    }
}

class SalonKadai2Tests: XCTestCase {
    private var changeText: String?
    
    private let notificationCenter = NotificationCenter()
    private var fakeModel: FakeModel!
    private var viewModel: ViewModel!
    
    func test_calculateResult() {
        XCTContext.runActivity(named: "足し算結果のテスト") { _ in
            let result = CalculateState.plus.calculate(first: 1, second: 1)
            XCTAssertEqual(2, result)
        }
        XCTContext.runActivity(named: "引き算結果のテスト") { _ in
            let result = CalculateState.minus.calculate(first: 2, second: 1)
            XCTAssertEqual(1, result)
        }
        XCTContext.runActivity(named: "掛け算結果のテスト") { _ in
            let result = CalculateState.multipliedBy.calculate(first: 2, second: 3)
            XCTAssertEqual(6, result)
        }
        XCTContext.runActivity(named: "割り算結果のテスト") { _ in
            let result = CalculateState.dividedBy.calculate(first: 10, second: 2)
            XCTAssertEqual(5, result)
        }
    }
    
    func test_changeValidationText() {
        XCTContext.runActivity(named: "バリデーションに成功する場合") { _ in
            // Given
            setup()
            fakeModel.result = .success(String(3)) // 成功パターン3を検証
            // When
            viewModel.numberInputed(firstNumber: String(1), secondNumber: String(2), index: 0) // postするために呼ぶ。値はなんでもいい。FakeModelのresultがchangeTextにpostされる
            
            XCTAssertEqual("3", changeText)
            
            clean()
        }
        
        XCTContext.runActivity(named: "バリデーションに失敗する場合") { _ in
            setup()
            fakeModel.result = .failure(ModelError.invalidBothNumbers)
            
            viewModel.numberInputed(firstNumber: nil, secondNumber: nil, index: 0)
            
            XCTAssertEqual("未入力が２箇所あります", changeText)
            
            clean()
        }
        
        XCTContext.runActivity(named: "1つ目の数字が未入力の場合") { _ in
            setup()
            fakeModel.result = .failure(ModelError.invalidFirstNumber)
            
            viewModel.numberInputed(firstNumber: nil, secondNumber: "2", index: 0)
            
            XCTAssertEqual("1つ目が未入力です", changeText)
            
            clean()
        }

        XCTContext.runActivity(named: "2つ目の数字が未入力の場合") { _ in
            setup()
            fakeModel.result = .failure(ModelError.invalidSecondNumber)
            
            viewModel.numberInputed(firstNumber: "2", secondNumber: nil, index: 0)
            
            XCTAssertEqual("2つ目が未入力です", changeText)
            
            clean()
        }
        
        XCTContext.runActivity(named: "割る数が０の場合") { _ in
            setup()
            fakeModel.result = .failure(ModelError.invalidDividedByZero)
            
            viewModel.numberInputed(firstNumber: "2", secondNumber: "0", index: 3)
            
            XCTAssertEqual("割る数には０以外の数字を入力してください", changeText)
            
            clean()
        }
    }

    private func setup() {  // ViewControllerでやってることぽい？
        fakeModel = FakeModel()
        viewModel = ViewModel(
            notificationCenter: notificationCenter,
            model: fakeModel
        )
        
        notificationCenter.addObserver(self,
                                       selector: #selector(changeTextReceiver),
                                       name: viewModel.changeResultLabel, object: nil)
        
    }
    
    @objc private func changeTextReceiver(notification: Notification) {
        guard let text = notification.object as? String else {
            XCTFail("Fail to convert text")
            fatalError()
        }
        changeText = text
    }
    
    private func clean() {
        fakeModel = nil
        viewModel = nil
    }

}
