note
	description: "[
		Keep track of birthdays for friends.
		Model is FUN[NAME,BIRTHDAY]
		Efficient implementation with ARRAY and LINKED_LIST
	]"
	author: "JSO"
	date: "2020-01-30"
	revision: "$Revision$"

class
	EXERCISE

inherit

	ANY
		redefine
			out
		end

create
	make

feature {NONE, ES_TEST} -- implementation

	imp : ARRAY[TUPLE[name: NAME; bd : BIRTHDAY]]
	--change post-condition of model and 'count'
	
	list : LINKED_LIST[TUPLE[name: NAME; bd : BIRTHDAY]]
	--change post-condition of model and 'count'

	make
			-- create a birthday book
		do
			create imp.make_empty
			imp.compare_objects
			create list.make
			list.compare_objects

		ensure
			model.is_empty
		end

feature -- model

	model: FUN [NAME, BIRTHDAY]
			-- model is a function from NAME --> BIRTHDAY
			-- abstraction function
			-- glue concrete implementation of birthday book
			-- to the abstract model representation
		local
			a_name : NAME
			a_date : BIRTHDAY

		do
			create Result.make_empty
			
			--Implementation with ARRAY
--			across imp is tuple
--			loop
--				a_name := tuple.name
--				a_date := tuple.bd
--				Result.extend ([a_name, a_date])
--			end

			-- implementation with LINKED_LIST
			across list is tuple
			loop
				a_name := tuple.name
				a_date := tuple.bd
				Result.extend ([a_name, a_date])
			end


		ensure -- ∀name ∈ Result.domain: Result[name] = imp[name]

			across Result.domain is al_name all
				list.has ([al_name, Result[al_name]])				
			end
			same_count: Result.count = list.count
		end

feature -- command

	put (a_name: NAME; d: BIRTHDAY)
			-- add birthday for `a_name' at date `d'
			-- or overrride current birthday with new

		local
			array : ARRAY[NAME]

		do
			--Implementation with ARRAY
--			if imp.has ([a_name, d]) then
--				across imp is tuple
--				loop
--					if tuple.name ~ a_name then
--						tuple.bd := d
--					end
--				end
--			else
--				imp.force ([a_name, d], imp.count + 1)
--			end

			-- implementation with LINKED_LIST

			create array.make_empty
			across list as tuple
			loop
				array.force (tuple.item.name, array.count + 1)
			end

			if array.has (a_name) then
				across list as tuple
				loop
					if tuple.item.name ~ a_name then
						tuple.item.bd := d
					end
				end
			else
				list.extend ([a_name, d])
			end

		ensure
			model_override: -- model = (old model)↾[a_name, d]
				model ~ (old model.deep_twin @<+ [a_name, d])
		end

	remove (a_name : NAME; d : BIRTHDAY)
		-- Remove a_name and 'd' from the Birthday_Book
		do
			 --Implementation with ARRAY
--				across 1 |..| imp.count is i
--				loop
--					if imp.at (i).name ~ a_name then
--						imp.prune_all (imp.at (i))
--					end
--				end

			--Implementation with LINKED_LIST
			across 1 |..| list.count is i
				loop
					if list[i].name ~ a_name then
						list.prune ([a_name, d])
					end
				end


		ensure
			model_not_have: not model.has ([a_name, d])
		end

feature -- queries
	remind (d: BIRTHDAY): ARRAY [NAME]
			-- returns an array of names with birthday `d'
		local
			l_name: NAME
			l_date: BIRTHDAY
		do
			create Result.make_empty
			Result.compare_objects

			-- Implementation with Array
--			across imp is tuple
--			loop
--				l_name := tuple.name
--				l_date := tuple.bd
--				if l_date ~ d then
--					Result.force(l_name, Result.count + 1)
--				end
--			end

			--Implementation with LINKED_LIST
			across list is tuple
			loop
				l_name := tuple.name
				l_date := tuple.bd
				if l_date ~ d then
					Result.force(l_name, Result.count + 1)
				end
			end

		ensure
			remind_count:
				Result.count = (model @> (d)).count
			remind_model_range_restriction: -- model ▷ {d}
				across (model @> (d)).domain is al_name all
					Result.has (al_name)
				end
			model_unchanged:
				model ~ old model.deep_twin
		end

	count: INTEGER
		do
			Result := list.count
		end

	out: STRING
		do
			Result := model.out
		end

invariant
	count =  model.count
end
