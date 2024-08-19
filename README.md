# NoLogger

[![Swift](https://img.shields.io/badge/Swift-5.5-orange.svg?style=flat)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS%20|%20Linux-blue.svg)](https://developer.apple.com/platforms/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

NoLogger is a lightweight, easy-to-use logging library designed for server-side Swift applications. It allows developers to log messages at different log levels (debug, info, warning, error, critical) with minimal setup. The logger supports output to the console or a custom handler, ensuring that you have full control over your logging behavior.

## Features

- **Log Levels**: Filter logs by levels: `debug`, `info`, `warning`, `error`, `critical`.
- **Thread Safety**: Logging operations are performed on a serial queue to ensure thread safety.
- **Custom Output**: Choose between console output or provide a custom handler.
- **@autoclosure @escaping**: Messages are constructed as needed via autoclosures, deferring potentially expensive operations unless the log level actually requires them.

## Installation

### Swift Package Manager

Add NoLogger as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/NoLogger.git", from: "1.0.0")
]
```

Then include it as a dependency in your target:

```swift
.target(
    name: "YourApp",
    dependencies: ["NoLogger"]
)
```

Finally, import the NoLogger module in your Swift files:

```swift
import NoLogger
```

## Usage

### Basic Example

To get started with logging, create an instance of `NoLogger` and use it in your code:

```swift
import NoLogger

let logger = NoLogger(minLogLevel: .info, output: .console)

func exampleFunction() {
    logger.log(.debug, "This is a debug message") // Will not print if minLogLevel is .info or higher
    logger.log(.info, "Informational message logged")
    logger.log(.error, "This is an error message within exampleFunction")
}

exampleFunction()
```

### Log Levels
NoLogger supports the following log levels:

- **`.debug`**: For debugging information.
- **`.info`**: General informational messages that highlight the progress of the application.
- **`.warning`**: An indication that something unexpected happened, or might happen in the future (e.g., "disk space low").
- **`.error`**: Due to a more serious problem, the software has not been able to perform some functions.
- **`.critical`**: A serious error, indicating that the program itself may be unable to continue running.

Log levels are checked, and only messages with a level equal to or greater than the `minLogLevel` are logged.

### Custom Output Handler

You can define your own custom log handler instead of using the console:

```swift
let customHandler: (String) -> Void = { message in
    // Write the log message to a file, send it to a server, etc.
    print("[CustomLogger] \(message)")
}

let logger = NoLogger(minLogLevel: .debug, output: .custom(customHandler))

logger.log(.info, "This message will be handled by customHandler")
```

## License

NoLogger is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Contributing

Feel free to fork the repository and open a pull request if you have any improvements! For major changes, please open an issue first to discuss what you would like to change.
