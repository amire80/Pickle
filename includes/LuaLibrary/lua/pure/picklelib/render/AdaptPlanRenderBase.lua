--- Baseclass for report renderer
-- luacheck: globals mw

-- @var class var for lib
local AdaptPlanRender = {}

--- Lookup of missing class members
function AdaptPlanRender:__index( key ) -- luacheck: ignore self
	return AdaptPlanRender[key]
end

--- Create a new instance
function AdaptPlanRender.create( ... )
	local self = setmetatable( {}, AdaptPlanRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function AdaptPlanRender:_init( ... ) -- luacheck: ignore
	return self
end

--- Override key construction
function AdaptPlanRender:key( str ) -- luacheck: ignore
	error('Method should be overridden')
	return nil
end

--- Realize reported data for skip
-- The "skip" is a message identified by a key.
function AdaptPlanRender:realizeSkip( src, lang )
	assert( src, 'Failed to provide a source' )

	if not src:hasSkip() then
		return ''
	end

	local realization = ''
	local inner = mw.message.new( src:getSkip() )

	if lang then
		inner:inLanguage( lang )
	end

	if not inner:isDisabled() then
		realization = inner:plain()
	end

	local outer = mw.message.new( self:key( 'wrap-skip' ), realization )

	if lang then
		outer:inLanguage( lang )
	end

	if outer:isDisabled() then
		return realization
	end

	return outer:plain()
end

--- Realize reported data for todo
-- The "todo" is a text string.
function AdaptPlanRender:realizeTodo( src, lang )
	assert( src, 'Failed to provide a source' )

	if not src:hasTodo() then
		return ''
	end

	local realization = mw.text.encode( src:getTodo() )
	local outer = mw.message.new( self:key( 'wrap-todo' ), realization )

	if lang then
		outer:inLanguage( lang )
	end

	if outer:isDisabled() then
		return realization
	end

	return outer:plain()
end

--- Realize reported data for description
-- The "description" is a text string.
function AdaptPlanRender:realizeDescription( src, lang )
	assert( src, 'Failed to provide a source' )

	if not src:hasDescription() then
		return ''
	end

	local realization = mw.text.encode( src:getDescription() )
	local outer = mw.message.new( self:key( 'wrap-description' ), realization )

	if lang then
		outer:inLanguage( lang )
	end

	if outer:isDisabled() then
		return realization
	end

	return outer:plain()
end

--- Realize reported data for state
function AdaptPlanRender:realizeState( src, lang )
	assert( src, 'Failed to provide a source' )

	local msg = mw.message.new( src:isOk() and self:key( 'is-ok' ) or self:key( 'is-not-ok' ) )

	if lang then
		msg:inLanguage( lang )
	end

	if msg:isDisabled() then
		return ''
	end

	return msg:plain()
end

--- Realize reported data for header
-- The "header" is a composite.
function AdaptPlanRender:realizeHeader( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = { self:realizeState( src, lang ) }

	if src:hasDescription() then
		table.insert( t, self:realizeDescription( src, lang ) )
	end

	if src:hasSkip() or src:hasTodo() then
		table.insert( t, '# ' )
		table.insert( t, self:realizeSkip( src, lang ) )
		table.insert( t, self:realizeTodo( src, lang ) )
	end

	return table.concat( t, '' )
end

--- Realize reported data for a line
function AdaptPlanRender:realizeLine( param, lang )
	assert( param, 'Failed to provide a parameter' )

	local realization = ''
	local inner = mw.message.new( unpack( param ) )

	if lang then
		inner:inLanguage( lang )
	end

	if not inner:isDisabled() then
		realization = inner:plain()
	end

	realization = mw.text.encode( realization )

	local outer = mw.message.new( self:key( 'wrap-line' ), realization )

	if lang then
		outer:inLanguage( lang )
	end

	if outer:isDisabled() then
		return realization
	end

	return outer:plain()
end

--- Realize reported data for body
-- The "body" is a composite.
function AdaptPlanRender:realizeBody( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = {}

	for _,v in ipairs( { src:lines() } ) do
		table.insert( t, self:realizeLine( v, lang ) )
	end

	return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end

-- Return the final class
return AdaptPlanRender