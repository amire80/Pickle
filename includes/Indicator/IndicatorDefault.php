<?php

namespace Spec;

/**
 * Concrete strategy for indicators
 * Encapsulates a default indicator as an adapter. The default indicator is used when no other
 * matching entry can be found.
 *
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */
class IndicatorDefault extends IndicatorBase {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [], $opts, [ 'name' => 'unknown' ] );
	}
}
