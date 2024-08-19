// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// Enum for different log levels
public enum LogLevel: Int {
    case no         // No logging
    case debug      // Debug-level logging
    case info       // Informational logging
    case warning    // Warnings
    case error      // Errors only
    case critical   // Critical errors, often leading to termination in some contexts
    
    var description: String {
        switch self {
        case .no:
            return "NO LOGGING"
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        case .critical:
            return "CRITICAL"
        }
    }
}

/// A logger class intended for server-side applications
public final class NoLogger {
    
    // MARK: - Properties
    
    /// The minimum level of log to actually log
    private let minLogLevel: LogLevel
    
    /// The output where the logs will be written
    private let output: Output
    
    /// A serial queue to ensure thread-safe logging
    private let loggingQueue = DispatchQueue(label: "com.nologger.queue")
    
    /// Log output options
    public enum Output {
        case console
        case custom((String) -> Void)
    }
    
    // MARK: - Initializer
    
    /// Initializes the logger with a minimum log level and output
    public init(minLogLevel: LogLevel = .debug, output: Output = .console) {
        self.minLogLevel = minLogLevel
        self.output = output
    }
    
    // MARK: - Logging Methods
    
    /// Logs a message with the given level
    public func log(_ level: LogLevel, _ message: @autoclosure @escaping () -> Any, function: String = #function, line: Int = #line) {
        guard level.rawValue >= minLogLevel.rawValue else {
            return
        }
        
        loggingQueue.async { [weak self] in
            guard let self = self else { return }
            let logEntry = self.formatLog(level, message(), function: function, line: line)
            self.write(logEntry)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Formats the log entry
    private func formatLog(_ level: LogLevel, _ message: Any, function: String, line: Int) -> String {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        
        return """
        [\(timestamp)] [\(level.description)] [\(function):\(line)] - \(message)
        """
    }
    
    /// Writes the log to the specified output
    private func write(_ message: String) {
        switch output {
        case .console:
            print(message)
        case .custom(let handler):
            handler(message)
        }
    }
}
