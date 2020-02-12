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
	BIRTHDAY_BOOK

inherit

	ANY
		redefine
			out
		end

create
	make

feature {NONE, ES_TEST} -- implementation

	imp: HASH_TABLE [BIRTHDAY, NAME]
			-- implementation as an efficient hash table

	make
			-- create a birthday book
		do
			create imp.make (10)
			imp.compare_objects
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
			l_name: NAME
			l_date: BIRTHDAY
		do
			create Result.make_empty
			from
				imp.start
			until
				imp.after
			loop
				l_name := imp.key_for_iteration
				l_date := imp [l_name]
				check attached l_date as l_date2 then
					Result.extend ([l_name, l_date2])
				end
				imp.forth
			end
			imp.start
		ensure -- ∀name ∈ Result.domain: Result[name] = imp[name]
			across Result.domain is al_name all
				imp.has (al_name)
				and then imp [al_name] ~ Result[al_name]
			end
			same_count: Result.count = imp.count
		end

feature -- command

	put (a_name: NAME; d: BIRTHDAY)
			-- add birthday for `a_name' at date `d'
			-- or overrride current birthday with new
		do
			if not imp.has_key (a_name) then
				imp.extend (d, a_name)
			else
				imp.replace (d, a_name)
			end
		ensure
			model_override: -- model = (old model)↾[a_name, d]
				model ~ (old model.deep_twin @<+ [a_name, d])
		end

feature -- queries
	remind (d: BIRTHDAY): ARRAY [NAME]
			-- returns an array of names with birthday `d'
		local
			l_name: NAME
			l_date: BIRTHDAY
			i: INTEGER
		do
			create Result.make_empty
			Result.compare_objects
			from
				imp.start
			until
				imp.after
			loop
				l_name := imp.key_for_iteration
				l_date := imp [l_name]
				if l_date ~ d then
					Result.force (l_name, i)
					i := i + 1
				end
				imp.forth
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
