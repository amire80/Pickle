--- Tests for the boolean false extractor module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local name = 'extractor'

local function makeTest( ... )
	local lib = require 'picklelib/extractor/ExtractorFalse'
	assert( lib )
	return lib:create( ... )
end

local function testExists()
	return type( makeTest() )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testType( ... )
	return makeTest( ... ):type()
end

local function testFind( str, ... )
	return makeTest( ... ):find( str, 1 )
end

local function testCast( ... )
	return makeTest():cast( ... )
end

local function testPlaceholder()
	return makeTest():placeholder()
end

local tests = {
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = name .. ':create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{
		name = name .. ':create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{
		name = name .. ':create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{
		name = name .. ':type ()',
		func = testType,
		expect = { 'false' }
	},
	{
		name = name .. ':find (not matched)',
		func = testFind,
		args = { 'foo bar baz' },
		expect = {}
	},
	{
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'false' },
		expect = { 1, 5 }
	},
	{
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'false bar baz' },
		expect = { 1, 5 }
	},
	{
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'foo false baz' },
		expect = { 5, 9 }
	},
	{
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'foo bar false' },
		expect = { 9, 13 }
	},
	{
		name = name .. ':cast (empty)',
		func = testCast,
		expect = { false }
	},
	{
		name = name .. ':placeholder ()',
		func = testPlaceholder,
		args = {},
		expect = { 'boolean' }
	},
}

return testframework.getTestProvider( tests )
