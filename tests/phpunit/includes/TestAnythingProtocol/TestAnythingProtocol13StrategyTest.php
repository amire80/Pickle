<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TestAnythingProtocol13Strategy;

/**
 * @group Spec
 *
 * @covers \Spec\TestAnythingProtocol13Strategy
 */
class TestAnythingProtocol13StrategyTest extends TestAnythingProtocolStrategyTestCase {

	protected $conf = [
		"class" => "Spec\\TestAnythingProtocol13Strategy",
		"name" => "test"
	];

	protected function newInstance( $conf ) {
		return new TestAnythingProtocol13Strategy( $conf );
	}

	public function provideGetName() {
		return [
			[
				'foo',
				[
					"class" => "Spec\\TestAnythingProtocol13Strategy",
					"name" => "foo"
				]
			],
			[
				'tap-13',
				[
					"class" => "Spec\\TestAnythingProtocol13Strategy"
				]
			]
		];
	}

	public function providerForStats() {
		return [
			[
				[
					[ 2, 0, 0 ],
					[ 2, 0, 1 ]
				],
				"ok 1 - Input file opened\n"
				. "not ok 2 - First line of the input valid\n"
				. "ok 3 - Read the rest of the file\n"
				. "not ok 4 - Summarized correctly # TODO Not written yet"
			]
		];
	}

	/**
	 * @dataProvider providerForStats
	 */
	public function testOnStats( $expect, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertEquals( $expect, $test->stats( $str ) );
	}

	public function provideValidExamples() {
		return [
			[ 'bad', true, "TAP version 13\nok 1 - test\n" ],
			[ 'good', true, "TAP version 13\nnot ok 1 - test\n" ],
			[ 'todo', true, "TAP version 13\nnot ok 1 - #todo\n" ],
			[ 'skipped', true, "TAP version 13\nnot ok 1 - #skipped\n" ]
		];
	}

	/**
	 * @dataProvider provideValidExamples
	 */
	public function parse( $type, $valid, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertEquals( $type, $test->parse( $str ) );
	}

	/**
	 * @dataProvider provideValidExamples
	 */
	public function testOnCheckValid( $result, $valid, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertEquals( $valid, $test->checkValid( $str ) );
	}
}
