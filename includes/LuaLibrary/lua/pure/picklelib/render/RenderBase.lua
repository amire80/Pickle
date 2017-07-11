--- Baseclass for renders

-- @var class var for lib
local Render = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Render:__index( key ) -- luacheck: no self
	return Render[key]
end

--- Create a new instance
-- @param vararg unused
-- @return Render
function Render.create( ... )
	local self = setmetatable( {}, Render )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return Render
function Render:_init( ... ) -- luacheck: no unused args
	self._type = 'base-render'
	return self
end

--- Override key construction
-- Sole purpose of this is to do assertions, and the provided key is never be used.
-- @param string to be appended to a base string
-- @return string
function Render:key( str ) -- luacheck: no self
	assert( str, 'Failed to provide a string' )
	local keep = string.match( str, '^[-%a]+$' )
	assert( keep, 'Failed to find a valid string' )
	return 'pickle-report-base-' .. keep
end

--- Get the type of report
-- All reports has an explicit type name.
-- @return string
function Render:type()
	return self._type
end

--- Append same type to first
-- The base version only concatenates strings.
-- @param any to act as the head
-- @param any to act as the tail
-- @return any
function Render:append( head, tail ) -- luacheck: no self
	assert( head )
	assert( tail )
	return head .. ' ' .. tail
end

--- Realize clarification
-- @param string part of a message key
-- @param string optional language code
-- @return string
function Render:realizeClarification( keyPart, lang, counter )
	assert( keyPart, 'Failed to provide a key part' )

	local keyword = mw.message.new( self:key( keyPart .. '-keyword' ) )
		:inLanguage( 'en' )
		:plain()

	local msg = keyword .. ( counter and ( ' ' .. counter() ) or '' )

	if lang ~= 'en' then
		local translated = mw.message.new( self:key( keyPart .. '-keyword' ) )
			:inLanguage( lang )
		if not translated:isDisabled() then
			local str = translated:plain()
			if keyword ~= str then
				msg = msg .. ' ' .. mw.message.new( 'parentheses', str )
					:inLanguage( lang )
					:plain()
			end
		end
	end

	return msg
end

--- Realize comment
-- @param Report that shall be realized
-- @param string part of a message key
-- @param string optional language code
-- @return string
function Render:realizeComment( src, keyPart, lang )
	assert( src, 'Failed to provide a source' )

	local ucfKeyPart = string.upper( string.sub( keyPart, 1, 1 ) )..string.sub( keyPart, 2 )
	if not ( src['is'..ucfKeyPart]( src ) or src['has'..ucfKeyPart]( src ) ) then
		return ''
	end

	local str = src['get'..ucfKeyPart]( src )

	local desc = (not str)
		and mw.message.new( 'pickle-report-frame-' .. keyPart .. '-no-description' )
		or ( string.find( str, '^pickle-[-a-z]+$' )
			and mw.message.new( str )
			or mw.message.newRawMessage( str ) )

	if lang then
		desc:inLanguage( lang )
	end

	local clar = self:realizeClarification( 'is-' .. keyPart, lang )
	local msg = clar .. ( desc:isDisabled() and '' or ( ' ' .. desc:plain() ) )

	return msg
end

-- Return the final class
return Render
