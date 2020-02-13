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
			array : ARRAY[INTEGER]
			list : LINKED_LIST[INTEGER]
		do
			comment("t1: test Exercise")
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

			bb.put (jack, [25, 03])
			Result := bb.model.count = 2
				and bb.model[jack] ~ [25,03]
				and bb.model[jill] ~ [17,02]
				and bb.out ~ "{ Jack -> (25,3), Jill -> (17,2) }"
			check Result end

			-- Add birthday for Max
			bb.put (max, [17,02])
			assert_equal ("Max's birthday", bb.model[max], feb17)
			-- Whose birthday is Feb 17th?
			a := bb.remind ([17,02])
			Result := a.count = 2
				and a.has (max)
				and a.has (jill)
				and not a.has (jack)
			check Result end

			bb.remove (max, [17, 02])
			Result := bb.model.count = 2
				and bb.model[jack] ~ [25,03]
				and bb.model[jill] ~ [17,02]
				and bb.out ~ "{ Jack -> (25,3), Jill -> (17,2) }"
			check Result end
		end

		t2 : BOOLEAN
			local
				array: 	ARRAY[INTEGER]
				list:	LINKED_LIST[INTEGER]
			do
				comment("t2: basic data structures")
				create array.make_empty
				array.compare_objects
				array.force (1, array.count + 1)
				array.force (3, array.count + 1)
				Result := array.count = 2 and array[2] = 3 and array[1] = 1
				check Result end
				if array.has (3) then
					array.enter (5, 2)
				end
				Result := array.count = 2 and array[2] = 5 and array[1] = 1
				check Result end


				create list.make
				list.compare_objects
				Result := list.count = 0
				check Result end
				list.extend (7)
				list.extend (9)
				Result := list.count = 2 and list[1] = 7 and list[2] = 9
				check Result end
				list.prune (7)
				Result := list.count = 1 and list[1] = 9
				check Result end
				Result := list.count = 1 and list.has (9) and not list.has (7)
				check Result end
			end

end

