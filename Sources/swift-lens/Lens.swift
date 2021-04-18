//
//  Lens.swift
//  
//
//  Created by Nikolay Fiantsev on 18.04.2021.
//

import Foundation

precedencegroup LensSetterPrecedence { associativity: left lowerThan: DefaultPrecedence higherThan: LensPipePrecedence }
precedencegroup LensPipePrecedence { associativity: left lowerThan: DefaultPrecedence higherThan: TernaryPrecedence }

/*
 Lens base conception
 func get (Whole) -> Part
 func set (Part, Whole
 */

public struct Lens<A, B> {
  let get: (A) -> B
  let set: (B, A) -> A
  
  public init(get: @escaping (A) -> B, set: @escaping (B, A) -> A) {
    self.get = get
    self.set = set
  }
}

/// Lens composition
public func *<A, B, C>(lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
  return _compose(lhs: lhs, rhs: rhs)
}

/// Lens composition
public func *<A, B, C>(lhs: Lens<A, B?>, rhs: Lens<B, C>) -> Lens<A, C?> {
  return _compose(lhs: lhs, rhs: rhs)
}

/// Setter (takes Lens, Part and return function Whole->Whole)
infix operator *~ :  LensSetterPrecedence
public func *~<A, B>(lhs: Lens<A, B>, rhs: B) -> (A)->A {
  return { a in lhs.set(rhs, a) }
}

infix operator |> : LensPipePrecedence
/// Piping operator to get rid of syntax (User.name *~ "Joel")(myUser)
public func |> <A, B>(a: A, f: (A)->B) -> B {
  return f(a)
}

/// Piping operator to get rid of syntax (User.name *~ "Joel")(myUser)
public func |> <A, B, C>(f1: @escaping (A)->B, f2: @escaping (B)->C) -> (A)->C {
  return { a in f2(f1(a)) }
}

private func _compose<A, B, C>(lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
  return Lens<A, C>(
    get: { a in rhs.get(lhs.get(a)) },
    set: { (c, a) in lhs.set(rhs.set(c, lhs.get(a)), a) }
  )
}

private func _compose<A, B, C>(lhs: Lens<A, B?>, rhs: Lens<B, C>) -> Lens<A, C?> {
  return Lens<A, C?>(
    get: { a in lhs.get(a).flatMap(rhs.get) },
    set: { (c, a) in
      guard let unwrappedC = c else { return a }
      return lhs.set(lhs.get(a).map { rhs.set(unwrappedC, $0) }, a)
    }
  )
}
