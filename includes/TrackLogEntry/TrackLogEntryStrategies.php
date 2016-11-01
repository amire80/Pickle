<?php

namespace Spec;

/**
 * Strategy to create log entries
 *
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */
class TrackLogEntryStrategies extends Singletons {

	use TNamedStrategies;

	/**
	 * Who am I
	 */
	public static function who() {
		return __CLASS__;
	}

	/**
	 * Configure the strategies
	 */
	public static function init() {
		global $wgSpecTrackLogEntry;

		$results = TrackLogEntryStrategies::getInstance();
		foreach ( $wgSpecTrackLogEntry as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Add track log for tested module
	 * This is a callback for a hook registered in extensions.json
	 */
	public static function addLogEntry(
		\Title $title,
		\ParserOutput &$parserOutput,
		array $states = null
	) {

		if ( $states == null ) {
			return true;
		}

		$currentKey = $states[ 'status-current' ];
		$previousKey = $states[ 'status-previous' ];

		if ( $currentKey !== null
				&& $currentKey !== $previousKey
				&& in_array( $currentType, [ 'normal' ] ) ) {
			$strategy = self::getInstance()->find( $currentKey );
			if ( $strategy === null ) {
				return true;
			}
			$strategy->addLogEntry( $title );
		}

		return true;
	}


}
