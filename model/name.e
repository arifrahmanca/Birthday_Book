note
	description: "[
		An immutable name that is hashable
		]"
	author: "JSO"
	date: "2020-01-28"

class
	NAME

inherit

	ANY
		redefine
			is_equal,
			out
		end

	HASHABLE
		redefine
			is_equal,
			out
		end

create
	make

feature {NONE} -- Initialization
	hash_code: INTEGER
			-- make name hashable
		do
			Result := item.hash_code
		end

	make (a_name: STRING_32)
			-- create a name where first letter is a capital
		require
			65 <= a_name[1].code and a_name[1].code <= 90
		do
			item := a_name
		end

feature

	item: IMMUTABLE_STRING_32

	is_equal (other: like Current): BOOLEAN
		do
			Result := item ~ other.item
		end

	out: STRING
		do
			Result := item.out
		end

invariant
	item.count >= 1
	65 <= item[1].code and item[1].code <= 90
	-- item[1] ∈ A..Z
end
