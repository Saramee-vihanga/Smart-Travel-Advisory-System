% ************************************************************* 
% main, places and user fils must save in the prolog folder
% *************************************************************

:- consult('places.pl').
:- consult('user.pl').

:- dynamic user_climate/1.
:- dynamic user_budget/1.
:- dynamic user_interest/1.
:- dynamic user_activity/1.

% Mapping rules
map_choice(1, climate).
map_choice(2, budget).
map_choice(3, interest).
map_choice(4, activity).

start :-
	%User Interface
	nl,
	retractall(user_climate(_)),
    	retractall(user_budget(_)),
    	retractall(user_interest(_)),
    	retractall(user_activity(_)),

   	assertz(user_climate(notgiven)),
    	assertz(user_budget(notgiven)),
    	assertz(user_interest(notgiven)),
    	assertz(user_activity(notgiven)),

	write('Hello Welcom to SL Tour Guid System'), nl,
	menu.

menu :-
	write('Select which option you need to find places: (1/2/3/4)'), nl,
	write('1. climate'), nl,
	write('2. budget'), nl,
	write('3. interest'), nl,
	write('4. activity'), nl,nl,

	read(Input),
	
	% Validation
    	(map_choice(Input, Pref)
	->	    
            user_pref(Pref)
        ;
          write('Invalid input. Please try again.'), nl,
	  menu
        ).

ask_again :-
	   nl,
	   write('Would you like to check other options? (yes/no)'), nl,
           read(Choice),nl,
	 
	   ( Choice = yes
	   -> menu
	   ; Choice = no 
	   -> print 
	   ; write('Invalid input'),nl,
	   ask_again
	).

print:-
	nl,
	write('==== ALL the Places to visit based on your preference===='),nl,nl,

	recommend_places_combined,nl,

	write('Thank you for using Smart Travel Advisor!'), nl,
        write('Goodbye ^_^ !'), nl.

recommend_places_combined :-
    	user_climate(Climate),
    	user_budget(Budget),
    	user_interest(Interest),
    	user_activity(Activity),

	(findall(Place,match_places(Place, Climate, Budget, Interest, Activity),Places),
	length(Places, Count),
	write('number of places: '), write(Count),nl,nl,
    	print_list(Places)
       	).

print_list([]). %stopping condition
print_list([H|T]) :-
       write(H), nl,
       print_list(T).

match_places(Place, Climate, Budget, Interest, Activity) :-
    	places(Place, C, B, I, A),

    	(Climate == notgiven -> true ; Climate == C),
    	(Budget  == notgiven -> true ; Budget  == B),
    	(Interest == notgiven -> true ; Interest == I),
    	(Activity == notgiven -> true ; member(Activity, A)).


