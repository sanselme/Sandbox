// SPDX-License-Identifier: GPL-3.0
//
//  cli.swift
//  hello
//
//  Created by Schubert Anselme on 2024-11-11.
//

import ArgumentParser
import GRPCNIOTransportHTTP2
import v1

// fixme: replace with api instead of grpc api (which is for services)
@main
struct Greet: AsyncParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Send a request to the greeter server")

  @Option(help: "The port to listen on")
  var port: Int = 8080

  @Option(help: "The person to greet")
  var name: String = ""

  func run() async throws {
    try await withThrowingDiscardingTaskGroup { group in
      let client = GRPCClient(
        transport: try .http2NIOPosix(
          target: .ipv4(host: "127.0.0.1", port: self.port),
          config: .defaults(transportSecurity: .plaintext)))

      group.addTask {
        try await client.run()
      }

      defer {
        client.beginGracefulShutdown()
      }

      let greeter = v1.Api_V1_Greeter_Client(wrapping: client)
      let reply = try await greeter.sayHello(.with { $0.name = self.name })
      print(reply.message)
    }
  }
}
