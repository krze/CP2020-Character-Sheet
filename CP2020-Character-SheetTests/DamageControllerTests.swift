//
//  DamageControllerTests.swift
//  CP2020-Character-SheetTests
//
//  Created by Ken Krzeminski on 11/25/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

@testable import CP2020_Character_Sheet
import XCTest

final class DamageControllerTests: XCTestCase {
    
    private func makeDamageController(with delegate: TestDamageControllerDelegate) -> TotalDamageDataSource {
        let dataSource = TotalDamageDataSource(maxDamage: 40)
        dataSource.delegate = delegate
        return dataSource
    }
    
    func testIterateDamageUp() {
        let delegate = TestDamageControllerDelegate()
        let controller = makeDamageController(with: delegate)
        
        try? controller.iterateDamageUp()
        
        XCTAssertEqual(controller.currentDamage, 1, "Damage did not iterate up.")
        XCTAssertTrue(delegate.damageCells.first?.backgroundColor == .red, "Delegate did not respond to controller.")
    }
    
    func testIterateDamageDown() {
        let delegate = TestDamageControllerDelegate()
        let controller = makeDamageController(with: delegate)
        
        try? controller.iterateDamageUp()
        try? controller.iterateDamageUp()
        try? controller.iterateDamageDown()
        
        XCTAssertEqual(controller.currentDamage, 1, "Damage did not iterate down.")
    }
    
    func testModifyDamageByArbitraryValue() {
        let delegate = TestDamageControllerDelegate()
        let controller = makeDamageController(with: delegate)
        
        try? controller.modifyDamage(by: 20)
        
        XCTAssertEqual(controller.currentDamage, 20, "Damage did not iterate down.")
    }
    
    func testErrorStates() {
        let delegate = TestDamageControllerDelegate()
        let controller = makeDamageController(with: delegate)
        
        var error: DamageModification?
        
        do {
            try controller.modifyDamage(by: 50)
        }
        catch let expectedError {
            guard let expectedError = expectedError as? DamageModification else {
                XCTFail("Not the right type of error.")
                return
            }
            error = expectedError
        }
        
        XCTAssertEqual(error, DamageModification.CannotExceedMaxDamage)
        
        do {
            try controller.modifyDamage(by: -1)
        }
        catch let expectedError {
            guard let expectedError = expectedError as? DamageModification else {
                XCTFail("Not the right type of error.")
                return
            }
            error = expectedError
        }
        
        XCTAssertEqual(error, DamageModification.CannotGoBelowZero)
        
        do {
            try controller.iterateDamageUp()
            try controller.modifyDamage(by: Int.max)
        }
        catch let expectedError {
            guard let expectedError = expectedError as? DamageModification else {
                XCTFail("Not the right type of error.")
                return
            }
            error = expectedError
        }
        
        XCTAssertEqual(error, DamageModification.BufferOverflow)
        
        do {
            try controller.modifyDamage(by: 0)
        }
        catch let expectedError {
            guard let expectedError = expectedError as? DamageModification else {
                XCTFail("Not the right type of error.")
                return
            }
            error = expectedError
        }
        
        XCTAssertEqual(error, DamageModification.NoModification)
    }
}

private final class TestDamageControllerDelegate: TotalDamageDataSourceDelegate {
    var damageCells = [DamageCell]()
        
    init() {
        damageCells.append(DamageCell(frame: CGRect(x: 0, y: 0, width: 20, height: 20)))
    }
    
    func updateCells(to currentDamage: Int) {
        damageCells.first?.markAsDamaged()
    }
    
    func reset() {
        damageCells.first?.markAsUndamaged()
    }

}
