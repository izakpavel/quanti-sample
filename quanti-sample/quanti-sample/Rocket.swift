//
//  Rocket.swift
//  quanti-sample
//
//  Created by Pavel Zak on 22.10.2024.
//

struct Rocket: Codable {
    let id: Int
    let active: Bool
    let stages: Int
    let boosters: Int
    let costPerLaunch: Double
    let successRatePct: Double
    let firstFlight: String
    let country: String
    let company: String
    let height: Dimensions
    let diameter: Dimensions
    let mass: Mass
    let payloadWeights: [PayloadWeight]
    let firstStage: FirstStage
    let secondStage: SecondStage
    let engines: Engines
    let landingLegs: LandingLegs
    let flickrImages: [String]
    let wikipedia: String
    let description: String
    let rocketId: String
    let rocketName: String
    let rocketType: String

    struct Dimensions: Codable {
        let meters: Double?
        let feet: Double?
        
        var formattedMeters: String {
            guard let meters = meters else { return "?" }
            return String(format: "%.0f", meters.rounded()) + "m"
        }
    }

    struct Mass: Codable {
        let kg: Double?
        let lb: Double?
        
        var formattedTons: String {
            guard let kg = kg else { return "?" }
            return String(format: "%.0f", (kg*0.001).rounded()) + "t"
        }
    }

    struct PayloadWeight: Codable {
        let id: String
        let name: String
        let kg: Double
        let lb: Double
    }
    
    struct Thrust: Codable {
        let kN: Int
        let lbf: Int
    }

    struct FirstStage: Codable {
        let reusable: Bool
        let engines: Int
        let fuelAmountTons: Double?
        let burnTimeSec: Double?
        let thrustSeaLevel: Thrust?
        let thrustVacuum: Thrust?
        
        enum CodingKeys: String, CodingKey {
            case reusable
            case engines
            case fuelAmountTons = "fuel_amount_tons"
            case burnTimeSec = "burn_time_sec"
            case thrustSeaLevel = "thrust_sea_level"
            case thrustVacuum = "thrust_vacuum"
        }
    }

    struct SecondStage: Codable {
        let reusable: Bool
        let engines: Int
        let fuelAmountTons: Double?
        let burnTimeSec: Double?
        let thrust: Thrust?
        let payloads: PayloadOptions?

        struct PayloadOptions: Codable {
            let option1: String?
            let option2: String?
            let compositeFairing: CompositeFairing?

            struct CompositeFairing: Codable {
                let height: Dimensions
                let diameter: Dimensions
            }

            enum CodingKeys: String, CodingKey {
                case option1 = "option_1"
                case option2 = "option_2"
                case compositeFairing = "composite_fairing"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case reusable
            case engines
            case fuelAmountTons = "fuel_amount_tons"
            case burnTimeSec = "burn_time_sec"
            case thrust
            case payloads
        }
    }

    struct Engines: Codable {
        let number: Int
        let type: String
        let version: String
        let layout: String?
        let isp: ISP
        let engineLossMax: Double?
        let propellant1: String
        let propellant2: String
        let thrustSeaLevel: Thrust
        let thrustVacuum: Thrust
        let thrustToWeight: Double

        struct ISP: Codable {
            let seaLevel: Double
            let vacuum: Double

            enum CodingKeys: String, CodingKey {
                case seaLevel = "sea_level"
                case vacuum
            }
        }

        enum CodingKeys: String, CodingKey {
            case number
            case type
            case version
            case layout
            case isp
            case engineLossMax = "engine_loss_max"
            case propellant1 = "propellant_1"
            case propellant2 = "propellant_2"
            case thrustSeaLevel = "thrust_sea_level"
            case thrustVacuum = "thrust_vacuum"
            case thrustToWeight = "thrust_to_weight"
        }
    }

    struct LandingLegs: Codable {
        let number: Int
        let material: String?
    }

    enum CodingKeys: String, CodingKey {
        case id
        case active
        case stages
        case boosters
        case costPerLaunch = "cost_per_launch"
        case successRatePct = "success_rate_pct"
        case firstFlight = "first_flight"
        case country
        case company
        case height
        case diameter
        case mass
        case payloadWeights = "payload_weights"
        case firstStage = "first_stage"
        case secondStage = "second_stage"
        case engines
        case landingLegs = "landing_legs"
        case flickrImages = "flickr_images"
        case wikipedia
        case description
        case rocketId = "rocket_id"
        case rocketName = "rocket_name"
        case rocketType = "rocket_type"
    }
}

extension Rocket: Equatable {
    static func == (lhs: Rocket, rhs: Rocket) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Rocket: Identifiable {
    
}

// MARK: convenience

protocol RocketStageDisplayable {
    var reusable: Bool { get }
    var engines: Int { get }
    var fuelAmountTons: Double? { get }
    var burnTimeSec: Double? { get }
}

extension Rocket.FirstStage: RocketStageDisplayable {
    
}

extension Rocket.SecondStage: RocketStageDisplayable {
    
}

extension RocketStageDisplayable {
    var formattedReusability: String {
        return reusable ? "Reusable" : "Not reusable"
    }
    
    var formattedEngines: String {
        return "\(engines) engines"
    }
    
    var formattedFuelAmount: String {
        guard let fuelAmountTons = fuelAmountTons else { return "Unknown fuel" }
        return String(format: "%.0f", fuelAmountTons.rounded()) + " tons of fuel"
    }
    
    var formattedBurnTime: String {
        guard let burnTimeSec = burnTimeSec else { return "Unknown burn time" }
        return String(format: "%.0f", burnTimeSec.rounded()) + " seconds burn time"
    }
}
