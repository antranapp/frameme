//
//  Logger.swift
//  FrameMe
//
//  Created by Josh Luongo on 20/5/2023.
//

import Foundation

public class Logger {

    /// Output (or log) a general output.
    ///
    /// - Parameter output: String to output
    public static func general(_ output: String) {
        print(output)
    }

    /// Output (or log) an error output.
    ///
    /// - Parameter output: String to output
    public static func error(_ output: String) {
        print(output.ansiRed)
    }

    /// Output (or log) a successful output.
    ///
    /// - Parameter output: String to output
    public static func success(_ output: String) {
        print(output.ansiGreen)
    }

    /// Output (or log) a successful output.
    ///
    /// - Parameter output: String to output
    public static func warning(_ output: String) {
        print(output.ansiYellow)
    }

}
