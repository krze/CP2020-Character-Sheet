//
//  DamageSectionViewModelTests.swift
//  CP2020-Character-SheetTests
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

@testable import CP2020_Character_Sheet
import XCTest

final class DamageSectionViewModelTests: XCTestCase {
    let cellCount = 4
    let startingNonMortalDamgeValue = 9
    let startingMortalDamageValue = 13
    let totalDamage = 40
    let typeRatio: CGFloat = 0.2
    let cellRatio: CGFloat = 0.4
    let stunRatio: CGFloat = 0.4
    let padding: CGFloat = 0.2
    
    private func makeTestModel(startingValue: Int, woundType: WoundType) -> DamageSectionViewModel {
        return DamageSectionViewModel(startingDamageCellNumber: startingValue,
                                      totalDamage: totalDamage,
                                      woundType: woundType,
                                      typeRatio: typeRatio,
                                      cellRatio: cellRatio,
                                      cellHorizontalPaddingSpace: padding,
                                      cellVerticalPaddingSpace: padding,
                                      cellBorderThickness: 1.0,
                                      cellCount: cellCount,
                                      stunRatio: stunRatio,
                                      darkColor: .black,
                                      lightColor: .white)
        
    }

    func testStunCount() {
        let model = makeTestModel(startingValue: startingNonMortalDamgeValue, woundType: .Critical)
        XCTAssertEqual(model.stunCount, 2, "Stun was not the expected value.")
        XCTAssertNil(model.mortalCount, "Mortal count was calculated for a non-mortal wound.")
    }

    func testMortalCount() {
        let model = makeTestModel(startingValue: startingMortalDamageValue, woundType: .Mortal)
        XCTAssertEqual(model.stunCount, 3, "Stun was not the expected value.")
        XCTAssertNotNil(model.mortalCount, "Mortal count was never calculated.")
        XCTAssertEqual(model.mortalCount, 0, "Mortal Count was not the expected value.")
    }
    
    func testHortizontalPadding() {
        let model = makeTestModel(startingValue: startingMortalDamageValue, woundType: .Mortal)

        XCTAssertEqual(model.damageCellHorizontalPadding, 0.04, "Padding was not evenly divided between 4 damage cells.")
    }

}
