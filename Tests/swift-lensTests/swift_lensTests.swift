import XCTest
@testable import swift_lens

final class swift_lensTests: XCTestCase {
  
  func testSetValueWithLens() {
    let myId = UUID()
    let newId = UUID()
    var user = User(id: myId, name: Name(first: "Joel"), address: nil)
    XCTAssertEqual(user.id, myId)
    user = user |> User.idLens *~ newId
    XCTAssertEqual(user.id, newId)
  }
  
  func testSetValueWithLensComposition() {
    var user = User(id: UUID(), name: Name(first: "Joel"), address: nil)
    XCTAssertEqual(user.name.first, "Joel")
    user = user |> (User.nameLens * Name.firstNameLens) *~ "Bin"
    XCTAssertEqual(user.name.first, "Bin")
  }
  
  func testCompositionLensWithOptionalType() {
    var user = User(id: UUID(), name: Name(first: "Joel"), address: Address(country: "USA"))
    XCTAssertEqual(user.address?.country, "USA")
    user = user |> (User.addressLens * Address.countryLens) *~ "Ukraine"
    XCTAssertEqual(user.address?.country, "Ukraine")
  }
    
  static var allTests = [
    ("testSetValueWithLens", testSetValueWithLens),
    ("testSetValueWithLensComposition", testSetValueWithLensComposition),
    ("testCompositionLensWithOptionalType", testCompositionLensWithOptionalType)
  ]
}

private struct User {
  let id: UUID
  let name: Name
  let address: Address?
}

private struct Name {
  let first: String
}

private struct Address {
  let country: String
}

extension User {
  static let idLens = Lens<User, UUID>(
    get: { user in user.id },
    set: { (id, user) in User(id: id, name: user.name, address: user.address) }
  )
  
  static let nameLens = Lens<User, Name>(
    get: { user in user.name },
    set: { (name, user) in User(id: user.id, name: name, address: user.address) }
  )
  
  static let addressLens = Lens<User, Address?>(
    get: { user in user.address },
    set: { (address, user) in User(id: user.id, name: user.name, address: address) }
  )
}

extension Name {
  static let firstNameLens = Lens<Name, String>(
    get: { name in name.first },
    set: { (firstName, _) in Name(first: firstName) }
  )
}

extension Address {
  static let countryLens = Lens<Address, String>(
    get: { address in address.country },
    set: { (country, _) in Address(country: country) }
  )
}
