import HeliumLogger
@_exported import LoggerAPI


public struct CoreLogger {

	public static func set(module: String?) {
		let logger = HeliumLogger()
        logger.format = "[(%date)] [(%type)] [\(module ?? "n/a")/(%file):(%line) (%func)] (%msg)"
		Log.logger = logger
	}

}
