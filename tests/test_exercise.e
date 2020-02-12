note
	description: "Summary description for {TEST_EXERCISE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_EXERCISE

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- run tests
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
		end

feature -- tests

	t1: BOOLEAN
	local
			feb17: BIRTHDAY
			bb: EXERCISE
			a: ARRAY[NAME]
			l_name: NAME
			l_birthday: BIRTHDAY
			jack,jill,max: NAME
		do
			comment("t1: test birthday book")
			create jack.make ("Jack"); create jill.make ("Jill")
			create max.make ("Max")
			create feb17.make (17, 02) -- Feb 17
			create bb.make
			-- add birthdays for Jack and Jill
			bb.put (jack, [14,01])  -- Jan 14
			bb.put (jill, [17,02])  -- Feb 17
			Result := bb.model.count = 2
				and bb.model[jack] ~ [14,01]
				and bb.model[jill] ~ [17,02]
				and bb.out ~ "{ Jack -> (14,1), Jill -> (17,2) }"
			check Result end
--			-- Add birthday for Max
--			bb.put (max, [17,02])
--			assert_equal ("Max's birthday", bb.model[max], feb17)
--			-- Whose birthday is Feb 17th?
--			a := bb.remind ([17,02])
--			Result := a.count = 2
--				and a.has (max)
--				and a.has (jill)
--				and not a.has (jack)
--			check Result end
		end

	t2: BOOLEAN
	do

	end
end
