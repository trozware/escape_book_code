//
// ISS_API.playground - Unit Conversions
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Foundation

let altitude = 408.05526028199
let velocity = 27635.971970874

let altitudeFormatter = MeasurementFormatter()
altitudeFormatter.numberFormatter.maximumFractionDigits = 1
altitudeFormatter.unitStyle = .long
altitudeFormatter.unitOptions = .providedUnit

let altitudeKm = Measurement(value: altitude, unit: UnitLength.kilometers)
print(altitudeKm)

let formattedAltitude = altitudeFormatter.string(from: altitudeKm)
print(formattedAltitude)

let altitudeMiles = altitudeKm.converted(to: UnitLength.miles)
print(altitudeMiles)

let formattedMiles = altitudeFormatter.string(from: altitudeMiles)
print(formattedMiles)

let velocityFormatter = MeasurementFormatter()
velocityFormatter.numberFormatter.maximumFractionDigits = 0
velocityFormatter.unitStyle = .short
velocityFormatter.unitOptions = .providedUnit

let velocityKmh = Measurement(value: velocity, unit: UnitSpeed.kilometersPerHour)
print(velocityKmh)

let formattedVelocity = velocityFormatter.string(from: velocityKmh)
print(formattedVelocity)

let velocityMph = velocityKmh.converted(to: UnitSpeed.milesPerHour)
print(velocityMph)

let formattedMph = velocityFormatter.string(from: velocityMph)
print(formattedMph)
