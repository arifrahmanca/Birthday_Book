note
	description: "[
		Keep track of birthdays for friends.
		Model is FUN[NAME,BIRTHDAY]
		Efficient implementation with hash table
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

--	imp: HASH_TABLE [BIRTHDAY, NAME]
			-- implementation as an efficient hash table
	imp : ARRAY[TUPLE[name: NAME; bd : BIRTHDAY]]
	array : ARRAY[NAME]
	list  : LINKED_LIST[BIRTHDAY]

	make
			-- create a birthday book
		do
			create imp.make_empty
			imp.compare_objects
			create array.make_empty
			create list.make
			array.compare_objects
			list.compare_objects
		ensure
			model.is_empty and
			array.is_empty and
			list.is_empty
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
--			i : INTEGER

		do

			create Result.make_empty
--			i := 1
			across 1 |..| array.count is i
			loop
				a_name := array.at (i)
				a_date := list.at (i)
				Result.extend ([a_name, a_date])
			end

--		do
--			create Result.make_empty
--			across imp is tuple
--			loop
--				a_name := tuple.name
--				a_date := tuple.bd
--				Result.extend ([a_name, a_date])
--			end

		ensure -- ∀name ∈ Result.domain: Result[name] = imp[name]

			across Result.domain is al_name all
				array.has (al_name)
--				imp.has ([al_name])
--				and then imp [al_name] ~ Result[al_name]
			end
			same_count: Result.count = array.count and Result.count = list.count
		end

feature -- command

	put (a_name: NAME; d: BIRTHDAY)
			-- add birthday for `a_name' at date `d'
			-- or overrride current birthday with new

		do
			if array.has (a_name) then
				across 1 |..| array.count is i
				loop
					if array.at (i) ~ a_name then
						list.at (i) := d
					end
				end
			else
					array.force (a_name, array.count + 1)
					list.extend (d)
--					list.forth
			end

--			if imp.has ([a_name, d]) then
--				across imp is tuple
--				loop
--					if tuple.name ~ a_name then
--						tuple.bd := d
--					end
--				end
--			else
--				imp.force ([a_name, d], imp.count+ 1)
--			end

		ensure
			model_override: -- model = (old model)↾[a_name, d]
				model ~ (old model.deep_twin @<+ [a_name, d])
--				model ~ (old model.deep_twin.overriden_by ([a_name, d]))

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
			across imp is tuple
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
			Result := imp.count
		end

	out: STRING
		do
			Result := model.out
		end

invariant
	count =  model.count
end
