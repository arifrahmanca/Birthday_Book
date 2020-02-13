note
	description: "Summary description for {TEST_EXERCISE_2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_EXERCISE_2

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- run tests
		do
			add_boolean_case (agent t1)
		end

feature -- tests

	t1: BOOLEAN
	local
			feb17: BIRTHDAY
			bb: EXERCISE_2
			a: ARRAY[NAME]
			l_name: NAME
			l_birthday: BIRTHDAY
			jack,jill,max: NAME
			array : ARRAY[INTEGER]
			list : LINKED_LIST[INTEGER]
		do
			comment("t1: test Exercise_2")
			create jack.make ("Jack"); create jill.make ("Jill")
			create max.make ("Max")
			create feb17.make (17, 02) -- Feb 17
			create bb.make

			-- add birthdays for Jack and Jill
			bb.put (jack, [14,01])  -- Jan 14
			bb.put (jill, [17,02])  -- Feb 17
			Result := bb.model.count = 2
				and bb.out ~ "{ Jack -> (14,1), Jill -> (17,2) }"
				and bb.model.domain.has (jack)
				and bb.model.domain.has (jill)
			check Result end

			bb.put (jack, [25, 03])
			Result := bb.model.count = 2
				and bb.out ~ "{ Jack -> (25,3), Jill -> (17,2) }"
				and bb.model.range.has ([25, 03])
			check Result end

--			-- Add birthday for Max
			bb.put (max, [17,02])
			Result := bb.model.count = 3
				and bb.out ~ "{ Jack -> (25,3), Jill -> (17,2), Max -> (17,2) }"
				and bb.model.domain.has (max)
			check Result end

--			-- Whose birthday is Feb 17th?
			a := bb.remind ([17,02])
			Result := a.count = 2
				and a.has (max)
				and a.has (jill)
				and not a.has (jack)
			check Result end

			bb.remove (max, [17, 02])
			Result := bb.model.count = 2
				and bb.out ~ "{ Jack -> (25,3), Jill -> (17,2) }"
				and not bb.model.domain.has (max)
			check Result end
		end

end
