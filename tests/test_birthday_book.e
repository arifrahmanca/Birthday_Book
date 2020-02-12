note
	description: "Test BIRTHDAY_BOOK"
	author: "JSO"
	date: "2020-01-28"

class
	TEST_BIRTHDAY_BOOK
inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- run tests
		do
			add_boolean_case (agent t0)
			add_boolean_case (agent t1)
		end

feature -- tests

	t0: BOOLEAN
		do
			comment("t0: a birthday has consistent (day, month)")
			Result := not {BIRTHDAY}.valid (30,2) -- 30th of Feb not valid
			check Result end
			Result := not {BIRTHDAY}.valid (31,4)
			check Result end
			Result := {BIRTHDAY}.valid (29,2) -- 29th Feb is valid
			check Result end
			Result := {BIRTHDAY}.valid (30,4)
			check Result end
			Result := not {BIRTHDAY}.valid (31,6)
			check Result end
			Result := not {BIRTHDAY}.valid (40,7)
			check Result end
			Result := not {BIRTHDAY}.valid (-78,22)
			check Result end
			Result := {BIRTHDAY}.duration.count = 12 -- entries
			check Result end
			Result := {BIRTHDAY}.valid (31,12)
		end


	t1: BOOLEAN
		local
			feb17: BIRTHDAY
			bb: BIRTHDAY_BOOK
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
			-- check efficient hash table implementation
--			across bb.model is al_pair loop
--				l_name := al_pair.first
--				l_birthday := al_pair.second
--				check
--					bb.imp.has (l_name)
--					and then bb.imp[l_name] ~ l_birthday
--				end
--			end
		end

end
