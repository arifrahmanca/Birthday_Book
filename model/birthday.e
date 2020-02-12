note
	description: "[
		A BIRTHDAY is a [day, month].
		valid(day,month) must hold true.
		Since there is no year, canot determine
		if Feb is 28 or 29 days.
		]"
	author: "JSO"
	date: "2020-01-28"

class BIRTHDAY inherit
	ANY
		redefine out end
create
	make,
	make_from_tuple

convert
	make_from_tuple ({TUPLE [INTEGER, INTEGER]})

feature {NONE} -- Initialization

	make (a_day: INTEGER; a_month: INTEGER)
		require valid(a_day, a_month)
		do
			month := a_month
			day := a_day
		end

	make_from_tuple (t: TUPLE [day: INTEGER; month: INTEGER])
		require
			t.count = 2
			attached {INTEGER} t.day
			attached {INTEGER} t.month
			valid(t.day,t.month)
		do
			make (t.day, t.month)
		end

feature
	duration: HASH_TABLE[INTEGER, INTEGER]
		-- maps MONTH to its longest DURATION
		once
			create Result.make (12)
			Result.put (31, 1)
			Result.put (29, 2)
			Result.put (31, 3)
			Result.put (30, 4)
			Result.put (31, 5)
			Result.put (30, 6)
			Result.put (30, 7)
			Result.put (31, 8)
			Result.put (30, 9)
			Result.put (31, 10)
			Result.put (30, 11)
			Result.put (31, 12)
		ensure class
		end

	day: INTEGER
	month: INTEGER

	basic_validity(a_day, a_month: INTEGER): BOOLEAN
		do
			Result :=
			    (1 <= a_day and a_day <= 31)
				and (1 <= a_month and a_month <= 12)
		ensure class
			Result implies (1 <= a_day and a_day <= 31)
			Result implies (1 <= a_month and a_month <= 12)
		end

	valid(a_day, a_month: INTEGER): BOOLEAN
		do
			if basic_validity(a_day, a_month) then
				Result := a_day <= duration[a_month]
			end
		ensure class
			Result implies basic_validity (a_day, a_month)
			Result implies a_day <= duration[a_month]
		end

	out: STRING
		do
			result := "(" + day.out + "," + month.out + ")"
		end

invariant
	1 <= month and month <= 12
	1 <= day and day <= 31
	valid(day, month)

end
