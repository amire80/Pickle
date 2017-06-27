<?php

namespace Pickle\Test\Full;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class AdaptFullRenderTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptFullRenderTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptFullRenderTest' => __DIR__ . '/AdaptFullRenderTest.lua'
		];
	}
}