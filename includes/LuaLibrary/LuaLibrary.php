<?php

namespace Pickle;

use Scribunto_LuaLibraryBase;

/**
 * Registers our lua modules to Scribunto
 *
 * @ingroup Extensions
 */

class LuaLibrary extends Scribunto_LuaLibraryBase {

	/**
	 * External Lua library for Scribunto
	 *
	 * @param string $engine
	 * @param array $extraLibraries
	 * @return bool
	 */
	public static function registerScribuntoLibraries( $engine, array &$extraLibraries ) {
		if ( $engine !== 'lua' ) {
			return true;
		}

		$extraLibraries['pickle'] = [
			'class' => '\Pickle\LuaLibrary',
			// @todo this should be deferred until it is used, this is preliminary
			'deferLoad' => false
		];

		return true;
	}

	/**
	 * Register the library
	 *
	 * @return array
	 */
	public function register() {
		global $wgPickleRenderStyles;
		global $wgPickleRenderTypes;
		global $wgPickleExtractorStrategy;

		return $this->getEngine()->registerInterface(
			__DIR__ . '/lua/non-pure/Pickle.lua',
			[ 'addResourceLoaderModules' => [ $this, 'addResourceLoaderModules' ] ],
			[
				'renderStyles' => $wgPickleRenderStyles,
				'renderTypes' => $wgPickleRenderTypes,
				'extractorStrategies' => $wgPickleExtractorStrategy ]
		);
	}

	/**
	 * Allows Lua to dynamically add the RL modules required for Pickle.
	 */
	public function addResourceLoaderModules() {
		$this->getParser()->getOutput()->addModuleStyles( 'ext.pickle.report' );
	}

}
