import XCTest

@testable import FTMS_iOS_Framework

class RowerDataCharacteristicTest: XCTestCase {

    // MARK: Stroke Rate

    func test_strokeRate_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(moreDataPresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.strokeRate)
    }

    func test_strokeRate_present_resultsIn_uint8Value_withBinaryExponentMinusOne() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(moreDataPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 7, // Stroke rate of 3.5
            0, // Stroke count value
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.strokeRate, 3.5)
    }

    // MARK: Stroke Count

    func test_strokeCount_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(moreDataPresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.strokeCount)
    }

    func test_strokeCount_present_resultsIn_uint16Value_lowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(moreDataPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 0, // Stroke Rate
            1, // Stroke count of 1
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.strokeCount, 1)
    }

    func test_strokeCount_present_resultsIn_uint16Value_highValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(moreDataPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 0, // Stroke Rate
            1, // Stroke count of 1 + 256
            1
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.strokeCount, 257)
    }

    // MARK: Average Stroke Rate

    func test_averageStrokeRate_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averageStrokeRatePresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.averageStrokeRate)
    }

    func test_averageStrokeRate_present_resultsIn_uint8Value_withBinaryExponentMinusOne() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averageStrokeRatePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 7)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averageStrokeRate, 3.5)
    }

    // MARK: Total Distance

    func test_totalDistance_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(totalDistancePresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.totalDistanceMeters)
    }

    func test_totalDistance_present_resultsIn_uint24Value_forLowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(totalDistancePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 0, 0)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.totalDistanceMeters, 1)
    }

    func test_totalDistance_present_resultsIn_uint24Value_forMediumValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(totalDistancePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 2, 0) // 1 + 512

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.totalDistanceMeters, 513)
    }

    func test_totalDistance_present_resultsIn_uint24Value_forHighValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(totalDistancePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 2, 4) // 1 + 512 + 262144

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.totalDistanceMeters, 262657)
    }

    // MARK: Instantaneous Pace

    func test_instantaneousPace_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(instantaneousPacePresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.instantaneousPaceSeconds)
    }

    func test_instantaneousPace_notPresent_resultsIn_uint16Value_forLowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(instantaneousPacePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 0)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.instantaneousPaceSeconds, 1)
    }

    func test_instantaneousPace_notPresent_resultsIn_uint16Value_forHighValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(instantaneousPacePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 2) // 1 + 512

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.instantaneousPaceSeconds, 513)
    }

    // MARK: Average Pace

    func test_averagePace_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averagePacePresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.averagePaceSeconds)
    }

    func test_averagePace_present_resultsIn_uint16Value_forLowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averagePacePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 0)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averagePaceSeconds, 1)
    }

    func test_averagePace_present_resultsIn_uint16Value_forHighValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averagePacePresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 2) // 1 + 512

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averagePaceSeconds, 513)
    }

    // MARK: Instantaneous Power

    func test_instantaneousPower_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(instantaneousPowerPresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.instantaneousPowerWatts)
    }

    func test_instantaneousPower_present_resultsIn_sint16Value_forLowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(instantaneousPowerPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 0)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.instantaneousPowerWatts, 1)
    }

    func test_instantaneousPower_present_resultsIn_sint16Value_forHighValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(instantaneousPowerPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 2) // 1 + 512

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.instantaneousPowerWatts, 513)
    }

    func test_instantaneousPower_present_resultsIn_sint16Value_forLowNegativeValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(instantaneousPowerPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 0b11111111, 0b11111111)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.instantaneousPowerWatts, -1)
    }

    func test_instantaneousPower_present_resultsIn_sint16Value_forHighNegativeValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(instantaneousPowerPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 0b11111111, 0b11111110)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.instantaneousPowerWatts, -257)
    }

    // MARK: Average Power

    func test_averagePower_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averagePowerPresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.averagePowerWatts)
    }

    func test_averagePower_present_resultsIn_sint16Value_forLowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averagePowerPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 0)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averagePowerWatts, 1)
    }

    func test_averagePower_present_resultsIn_sint16Value_forHighValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averagePowerPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 2) // 1 + 512

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averagePowerWatts, 513)
    }

    func test_averagePower_present_resultsIn_sint16Value_forLowNegativeValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averagePowerPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 0b11111111, 0b11111111)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averagePowerWatts, -1)
    }

    func test_averagePower_present_resultsIn_sint16Value_forHighNegativeValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(averagePowerPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 0b11111111, 0b11111110)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averagePowerWatts, -257)
    }

    // MARK: Resistance level

    func test_resistanceLevel_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(resistanceLevelPresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.resistanceLevel)
    }

    func test_resistanceLevel_present_resultsIn_sint16Value_forLowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(resistanceLevelPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 0)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.resistanceLevel, 1)
    }

    func test_resistanceLevel_present_resultsIn_sint16Value_forHighValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(resistanceLevelPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 1, 2) // 1 + 512

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.resistanceLevel, 513)
    }

    func test_resistanceLevel_present_resultsIn_sint16Value_forLowNegativeValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(resistanceLevelPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 0b11111111, 0b11111111)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.resistanceLevel, -1)
    }

    func test_resistanceLevel_present_resultsIn_sint16Value_forHighNegativeValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(resistanceLevelPresent: true)
        let data = CharacteristicData.create(flags: flags, values: 0b11111111, 0b11111110)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.resistanceLevel, -257)
    }

    // MARK: Total Energy

    func test_totalEnergy_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(expendedEnergyPresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.totalEnergyKiloCalories)
    }

    func test_totalEnergy_present_resultsIn_uint16Value_forLowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(expendedEnergyPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 1, // Total energy value 1
            0,
            0, // Energy per hour value
            0,
            0, // Energy per minute value
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.totalEnergyKiloCalories, 1)
    }

    func test_totalEnergy_present_resultsIn_uint16Value_forHighValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(expendedEnergyPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 1, // Total energy value 1 + 512
            2,
            0, // Energy per hour value
            0,
            0, // Energy per minute value
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.totalEnergyKiloCalories, 513)
    }

    // MARK: Energy Per Hour

    func test_energyPerHour_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(expendedEnergyPresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.energyPerHourKiloCalories)
    }

    func test_energyPerHour_present_resultsIn_uint16Value_forLowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(expendedEnergyPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 0, // Total energy value
            0,
            1, // Energy per hour value 1
            0,
            0, // Energy per minute value
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.energyPerHourKiloCalories, 1)
    }

    func test_energyPerHour_present_resultsIn_uint16Value_forHighValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(expendedEnergyPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 0, // Total energy value
            0,
            1, // Energy per hour value 1 + 512
            2,
            0, // Energy per minute value
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.energyPerHourKiloCalories, 513)
    }

    // MARK: Energy Per Minute

    func test_energyPerMinute_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(expendedEnergyPresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.energyPerMinuteKiloCalories)
    }

    func test_energyPerMinute_present_resultsIn_uint16Value_forLowValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(expendedEnergyPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 0, // Total energy value
            0,
            0, // Energy per hour value
            0,
            1, // Energy per minute value 1
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.energyPerMinuteKiloCalories, 1)
    }

    func test_energyPerMinute_present_resultsIn_uint16Value_forHighValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(expendedEnergyPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 0, // Total energy value
            0,
            0, // Energy per hour value
            0,
            1, // Energy per minute value 1 + 512
            2
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.energyPerMinuteKiloCalories, 513)
    }

    // MARK: Heart Rate

    func test_heartRate_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(heartRatePresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.heartRate)
    }

    func test_heartRate_present_resultsIn_uint8Value() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(heartRatePresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 170 // Heart rate of 170
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.heartRate, 170)
    }

    // MARK: Metabolic Equivalent

    func test_metabolicEquivalent_notPresent_resultsIn_nilValue() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(metabolicEquivalentPresent: false)
        let data = CharacteristicData.create(flags: flags)

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertNil(result.metabolicEquivalent)
    }

    func test_metabolicEquivalent_present_resultsIn_uint8Value() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(metabolicEquivalentPresent: true)
        let data = CharacteristicData.create(
            flags: flags,
            values: 123 // Metabolic Equivalent of 12.3
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.metabolicEquivalent, 12.3)
    }

    // MARK: Multiple properties present

    func test_multiplePropertiesPresent_properlyOffsetsValues_forAverageStrokeRateAndTotalDistance() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(
            averageStrokeRatePresent: true,
            totalDistancePresent: true
        )
        let data = CharacteristicData.create(
            flags: flags,
            values: 7, // Average stroke rate of 3.5
            16, // Total distance of 16
            0,
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averageStrokeRate, 3.5)
        XCTAssertEqual(result.totalDistanceMeters, 16)
    }

    func test_multiplePropertiesPresent_properlyOffsetsValues_forAverageStrokeRateAndInstantaneousPace() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(
            averageStrokeRatePresent: true,
            instantaneousPacePresent: true
        )
        let data = CharacteristicData.create(
            flags: flags,
            values: 7, // Average stroke rate of 3.5
            16, // Instantaneous pace of 16
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.averageStrokeRate, 3.5)
        XCTAssertEqual(result.instantaneousPaceSeconds, 16)
    }

    func test_multiplePropertiesPresent_properlyOffsetsValues_forTotalDistanceAndInstantaneousPace() {
        /* Given */
        let flags = RowerDataCharacteristicFlags.create(
            totalDistancePresent: true,
            instantaneousPacePresent: true
        )
        let data = CharacteristicData.create(
            flags: flags,
            values: 32, // Total distance of 32
            0,
            0,
            16, // Instantaneous pace of 16
            0
        )

        /* When */
        let result = RowerDataCharacteristic.decode(data: data)

        /* Then */
        XCTAssertEqual(result.totalDistanceMeters, 32)
        XCTAssertEqual(result.instantaneousPaceSeconds, 16)
    }
}
