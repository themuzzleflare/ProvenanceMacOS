import Foundation

enum TransactionCategory: String, CaseIterable {
  case all
  case gamesAndSoftware = "games-and-software"
  case carInsuranceAndMaintenance = "car-insurance-and-maintenance"
  case family
  case groceries
  case booze
  case clothingAndAccessories = "clothing-and-accessories"
  case cycling
  case homewareAndAppliances = "homeware-and-appliances"
  case educationAndStudentLoans = "education-and-student-loans"
  case eventsAndGigs = "events-and-gigs"
  case fuel
  case internet
  case fitnessAndWellbeing = "fitness-and-wellbeing"
  case hobbies
  case homeMaintenanceAndImprovements = "home-maintenance-and-improvements"
  case parking
  case giftsAndCharity = "gifts-and-charity"
  case holidaysAndTravel = "holidays-and-travel"
  case pets
  case transport
  case publicTransport = "public-transport"
  case hairAndBeauty = "hair-and-beauty"
  case lotteryAndGambling = "lottery-and-gambling"
  case homeInsuranceAndRates = "home-insurance-and-rates"
  case carRepayments = "car-repayments"
  case healthAndMedical = "health-and-medical"
  case pubsAndBars = "pubs-and-bars"
  case rentAndMortgage = "rent-and-mortgage"
  case taxisAndShareCars = "taxis-and-share-cars"
  case investments
  case restaurantsAndCafes = "restaurants-and-cafes"
  case tollRoads = "toll-roads"
  case utilities
  case lifeAdmin = "life-admin"
  case takeaway
  case mobilePhone = "mobile-phone"
  case tobaccoAndVaping = "tobacco-and-vaping"
  case newsMagazinesAndBooks = "news-magazines-and-books"
  case tvAndMusic = "tv-and-music"
  case adult
  case technology
}

extension TransactionCategory {
  var name: String {
    switch self {
    case .gamesAndSoftware:
      return "Apps, Games & Software"
    case .carInsuranceAndMaintenance:
      return "Car Insurance, Rego & Maintenance"
    case .family:
      return "Children & Family"
    case .homeMaintenanceAndImprovements:
      return "Maintenance & Improvements"
    case .newsMagazinesAndBooks:
      return "News, Magazines & Books"
    case .tollRoads:
      return "Tolls"
    case .carRepayments:
      return "Repayments"
    case .homeInsuranceAndRates:
      return "Rates & Insurance"
    case .tvAndMusic:
      return "TV, Music & Streaming"
    default:
      return self.rawValue.replacingOccurrences(of: "and", with: "&").replacingOccurrences(of: "-", with: " ").capitalized
    }
  }
}
