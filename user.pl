%==========================================================BUDGET SECTION==================================================================
%facts
budget(low,9000).
budget(medium,20000).
budget(high,45000).

% Main program
user_pref(budget):-
	write('======== Welcome to Smart Travel Advisor - Budget Planner ========'),nl,nl,
	write('Budget levels per day'),nl,nl,

	write('1. Low budget		LKR.9,000.00       $30'),nl,
	write('2. Medium budget    	LKR.20,000.00      $65'),nl,
	write('3. High budget   	LKR.45,000.00	   $150'),nl,nl,

	write('Budget schedule includes Food, Transport, Accomodation, Visiting place tickets and Activities.'),nl,nl,
	write('Note: International flights, Alcohol, Shopping, Tips and Travel Insurance are not included.'),nl,nl,nl,

	write('Enter your budget Level(low/medium/high): '),nl,
	read(Level),
	
	% Validation
	((Level = low ; Level = medium ; Level = high) ->
		retractall(user_budget(_)),
		assertz(user_budget(Level)),nl,

		write('==='),write(Level), write(' budget places you can go in Sri Lanka===='),nl,nl,
		budget_places(Level),nl,nl,

		write('How many days in your trip? '),nl,
		read(Days),

		budget(Level,Amount),
		Total is Amount * Days,nl,
		write('This is your trip Total budget: '),write('LKR.'),write(Total),nl,

		ask_again
	; 
		write('Invalid Input. Try Again.'),nl,nl,
		write('========================================================================'),nl,nl,
		user_pref(budget)
	).

%==========================================================CLIMATE SECTION==================================================================

% Climate preference handler
user_pref(climate) :-
	nl,
    	write('======== Welcome to Smart Travel Advisor - Climate Selector ========'), nl, nl,

    	write('Select your preferred climate:'), nl, nl,

    	write('1. Hot Climate (Beaches, Wildlife, Dry zones)'), nl,
    	write('2. Cold Climate (Mountains, Hill country)'), nl,nl,
    
    	write('Enter your choice (hot/cold): '),nl,
    	read(Input), nl,
	
	% Validation
	( (Input = hot ; Input = cold ) ->
        	retractall(user_climate(_)),
        	assertz(user_climate(Input)),nl,

        	write('Your climate preference saved successfully!'), nl,
	  	write('==='),write(Input), write(' places you can go in Sri Lanka===='),nl,nl,
	  	climate_places(Input),

        	ask_again

    	;
        	write('Invalid input. Please enter hot or cold '), nl,
		write('========================================================================'),nl,nl,
        	user_pref(climate)
    	).
	

%==========================================================INTEREST SECTION==================================================================
user_pref(interest) :-
	% Ask activity preference
	nl,
	write('which interest you prefer? '),nl,
	write('* beach'), nl,
    	write('* mountains'), nl,
    	write('* historical'), nl,
    	write('* wildlife'), nl, nl,
    	read(Interest),nl,

	% Validation
	( (Interest = beach ; Interest = mountains ; Interest = historical ; Interest = wildlife ) ->
        	retractall(user_interest(_)),
        	assertz(user_interest(Interest)),nl,

        	write('Your interest preference saved successfully!'), nl,
	  	write('==='),write(Interest), write(' places you can go in Sri Lanka===='),nl,nl,
	  	interest_places(Interest),

        	ask_again

    	;
        	write('Invalid input. Please enter again'), nl,
		write('========================================================================'),nl,nl,
        	user_pref(interest)
    	).


%==========================================================ACTIVITY SECTION==================================================================
user_pref(activity) :-
	write('======== Activity Selection - Smart Travel Advisor ========'), nl, nl,
	select_interest,
	user_interest(Type),

	show_activity_list(Type),
	get_activity_choice(Type, Activity),

	retractall(user_activity(_)),
    	assertz(user_activity(Activity)),

	show_activity_places(Activity),
	choice_again.

% ******************************** CHOICE AGAIN ********************************

choice_again :-
    nl,
    write('============================================================'), nl,
    write('Do you want to try another activity selection? (yes/no): '), nl,
    read(Ans),
    nl,
    ( Ans == yes ->
        retractall(user_interest(_)),
        retractall(user_activity(_)),
        user_pref(activity)
    ;
	ask_again        
    ).


% ******************************** INTEREST ********************************

select_interest :-
    write('======== Select Your Preferred Place Type ========'), nl, nl,
    write('1. beach'), nl,
    write('2. mountains'), nl,
    write('3. historical'), nl,
    write('4. wildlife'), nl, nl,
    read(Choice),

    ( map_interest(Choice, Interest) ->
        retractall(user_interest(_)),
        assertz(user_interest(Interest)),
        write('You selected: '), write(Interest), nl, nl
    ;
        write('Invalid Input. Try Again and enter the number.'), nl, nl,
        write('============================================================'), nl, nl,
        select_interest
    ).

map_interest(1, beach).
map_interest(2, mountains).
map_interest(3, historical).
map_interest(4, wildlife).

% ******************************** ACTIVITIES ********************************
activities(beach, [
    surfing, whale_watching, beach_relaxation,
    snorkeling, diving, turtle_hatchery,
    beach_yoga, lagoon_visit, sunset_view]).

activities(mountains, [
    hiking, ziplining, scenic_train_ride,
    little_adams_peak, ella_rock_hike,
    tea_plantation, waterfall_visit,
    tea_factory_visit, botanical_garden_visit,
    mountain_climbing, sunrise_view, temple_visit]).

activities(historical, [
    temple_visit, ruins_exploration,
    museum_visit, city_tour,
    tank_visit, cooking_class,
    cycling_tour, photography]).

activities(wildlife, [
    safari, elephant_safari,
    bird_watching, wildlife_photography,
    elephant_gathering, jeep_safari]).

% ******************************** SHOW ACTIVITIES ********************************

show_activity_list(Type) :-
    write('======== Available Activities for Selected Category ========'), nl, nl,
    activities(Type, List),
    print_list(List, 1), nl.

print_list([], _).
print_list([H|T], N) :-
    write(N), write('. '), write(H), nl,
    N1 is N + 1,
    print_list(T, N1).

% ******************************** GET ACTIVITY ********************************

get_activity_choice(Type, Activity) :-
    activities(Type, List),
    write('Select the activity you prefer by entering the number:'), nl,
    read(Num),
    length(List, Len),

    ( integer(Num), Num >= 1, Num =< Len ->
        nth1(Num, List, Activity)
    ;
        write('Invalid Input. Try Again.'), nl, nl,
        write('============================================================'), nl, nl,
        get_activity_choice(Type, Activity)
    ).

% ******************************** OUTPUT ********************************

show_activity_places(Activity) :-
    write('============================================================'), nl,
    write('Suggested places based on your choice:'), nl,
    write('============================================================'), nl,
    places(Place, _, _, _, Activities),
    member(Activity, Activities),
    write(Place), nl,
    fail.

show_activity_places(_) :-
    write('============================================================'), nl, nl.



%==========================================================SEPERATE RECOMENDATION SECTION============================================================

% Recommendation rule
climate_places(Climate) :-
    places(Place, Climate, _, _, _),
    write(Place), nl,
    fail.
climate_places(_).

% Recommendation rule
budget_places(Budget) :-
    places(Place, _, Budget, _, _),
    write(Place), nl,
    fail.
budget_places(_).

% Recommendation rule
interest_places(Interest) :-
    places(Place, _,_, Interest, _),
    write(Place), nl,
    fail.
interest_places(_).