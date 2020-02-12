note
	description: "Calendar application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT

inherit
	ARGUMENTS
	ES_SUITE

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			add_test (create {TEST_BIRTHDAY_BOOK}.make)
			add_test (create {TEST_EXERCISE}.make)
			show_browser
			run_espec
		end

end
