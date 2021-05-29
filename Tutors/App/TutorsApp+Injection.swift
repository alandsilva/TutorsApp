//
//  TutorsApp+Injection.swift
//  Tutors
//
//  Created by Alan on 28.5.2021.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    // register application components
    register { AuthenticationService() }.scope(.application)
  }
}