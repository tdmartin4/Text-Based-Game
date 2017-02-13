:- dynamic here/1.
:- dynamic location/2.
:- dynamic have/1.
:- dynamic intran_verb/3.
:- dynamic has/2.
:- dynamic text/2.
:- dynamic description/2.
:- dynamic door/2. 
:- dynamic want/2. 
:- dynamic blocked/1.

  
  
%% main to run the Password Protected game
%% user types start to begin the game
%% then outputs introduction to the game
%% then outputs location and current inventory
main:- password_protected.

password_protected:-
	nl,
	write('PASSWORD PROTECTED - A Prolog Adventure Game'), nl,
	write('Type Start to continue '),
	start_loop, nl, nl,
	retract(intran_verb(start, [start|A], A)),
	retract(intran_verb(start, ['Start'|A], A)),
	write('Welcome to Messiah College'),nl,
	write('Everyone\'s favorite professor Dr. Rohrbaugh has an issue.'),nl,
	write('He frequently forgets his password. Because of this, he has told '),nl,
	write('Dr. Weaver his password. However, now Dr. Rohrbaugh worries'),nl,
	write('that it is no longer secure. This is where you come in. '),nl,
	write('Dr. Rohrbaugh wants you to try to bypass whatever security'), nl,
	write('measures Dr. Weaver has used and discover the password... if possible.'), nl,
	write('Press enter to continue'), nl, get0(_),
	look, nl,
	inventory,
	command_loop.
	 
%% loop to force players to type start to begin the game
start_loop:-
	repeat,
	get_start(X),
	(X = start). 

%% loop to get the user's commands, process the commands, determine if
%% any puzzles were solved as a result of the command, and determine if the game should end
command_loop:-
	repeat,
	get_command(X),
	do(X),
	puzzle,
	(has(password, 'Dr. Rohrbaugh'); X == quit).
	
%% allows the user to quit the game
quit:-
	write('You\'re quitting already?'), nl,
	write('It seems Dr. Weaver must have hidden the password well.'), nl,
	write('Dr. Rohrbaugh should have nothing to worry about...'), nl,
	write('maybe.'), nl, nl,
	write('Game Over'), nl.
	
%% provides general help to user
help:-
	write('Type commands to see a list of commands.'), nl,
	write('Type shortcuts to see a list of shortcuts.'), nl.

%% lists all commands
commands:-
	not(list_commands), nl.
	
list_commands:-
	command(X, Y),
	tab(2), write(Y), write(' - '), write(X), nl,
	fail.
list_commands(_).

%% all available commands and their descriptions
command('allows the user to examine a person or object', 'examine [person/object]').
command('allows the user to go to another location', 'g [place]').
command('allows the user to go to another location', 'go [place]').
command('allows the user to go to another location', 'go in [place]').
command('allows the user to go to another location', 'go inside [place]').
command('allows the user to go to another location', 'go to [place]').
command('allows the user to view his or her items', 'inventory').
command('allows the user to look around the room', 'look').
command('allows the user to look around the room', 'look around').
command('allows the user to look inside an object', 'look in [object]').
command('allows the user to quit the game', 'quit').
command('gives the user a list of shortcuts', 'shortcuts').
command('allows the user to take an object if it an be taken', 'take [object]').
command('allows the user to talk to a person in general', 'talk [person]').
command('allows the user to talk to a person in general', 'talk to [person]').
command('allows the user to tell a person something specific', 'tell [person] [phrase]').
command('allows the user to use an object in the inventory', 'use [object] on [person/thing]').

 
shortcuts:-
	not(list_shortcuts), nl.

list_shortcuts:-
	shortcut(X, Y),
	tab(2), write(Y), write(' - '), write(X), nl,
	fail.
list_shortcuts(_).
shortcut('Any desk in a room', desk).
shortcut('Dr. Rohrbaugh', dr).
shortcut('Dr. Owen', do).
shortcut('Dr. Weaver', dw).
shortcut('Dr. Kilmer\'s office', dko).
shortcut('Dr. Rohrbaugh\'s office', dro).
shortcut('Dr. Weaver\'s office', dwo).
shortcut('Any person\'s key card', 'key card').
shortcut('outside Dr. Kilmer\'s office', 'outside dko').
shortcut('outside Dr. Rohrbaugh\'s office', 'outside dro').
shortcut('outside Dr. Weaver\'s office', 'outside dwo').
shortcut('outside Dr. Kilmer\'s office', odko).
shortcut('outside Dr. Rohrbaugh\'s office', odro).
shortcut('outside Dr. Weaver\'s office', odwo).
shortcut('the faculty lounge', tfl).


%% if Dr. Weaver is given coffee, he leaves the room, and the player can then
%% search the room for clues. The password piece and key card can only be found
%% once Dr. Weaver has left the room.
puzzle:-
	has(coffee, 'Dr. Weaver'),
	asserta(location('Dr. Weaver', away)),
	retract(location('Dr. Weaver', 'Dr. Weaver\'s office')),
	retract(has(coffee, 'Dr. Weaver')),
	retract(text('I sure could use some caffeine before I give my lecture...', 'Dr. Weaver')),
	text(Text, 'Dr. Weaver'),
	write('Dr. Weaver says '), nl,
	tab(2),
	write(Text),
	nl,
	write('Dr. Weaver left the room!'), nl,
	asserta(location('Dr. Weaver\'s key card', 'Dr. Weaver\'s desk')),
	asserta(location('piece 2', 'Networking textbook')),
	asserta(description('Dr. Weaver\'s computer. There\'s an email on the screen.', computer)),
	retract(description('Dr. Weaver\'s computer. There\'s something important-looking on the screen but you can\'t read it from here.', computer)).
	
%% if the keurig is given the keurig cups and mug, it will give the user coffee
puzzle:-
	has('keurig cups', keurig),
	has(mug, keurig),
	asserta(have(coffee)),
	retract(has('keurig cups', keurig)),
	retract(has(mug, keurig)),
	write('You got coffee!'), nl.
	
%% if the key card is used on the printer, the user will get a piece of the password
puzzle:-
	has('Dr. Weaver\'s key card', printer),
	assert(have('piece 1')),
	retract(has('Dr. Weaver\'s key card', printer)),
	write('You got a piece of Dr. Rohrbaugh\'s password!'), nl.
	
%% if the user has the pieces of the password in Weaver's office and Kilmer's office,
%% Dr. Rohrbaugh will give hints for getting the password piece from the printer
puzzle:-
	have('piece 2'),
	have('piece 3'),
	not(have('piece 1')),
	not(text('You need a key card to printer anything from the printers here.', 'Dr. Rohrbaugh')),
	retract(text(_, 'Dr. Rohrbaugh')),
	asserta(text('You need a key card to printer anything from the printers here.', 'Dr. Rohrbaugh')).
	
%% if the player has the piece from Dr. Weaver's office, but not the piece in Kilmer's office,
%% Dr. Rohrbaugh will give hints for finding the piece in Kilmer's office
puzzle:-
	have('piece 2'),
	not(have('piece 3')),
	not(text('I know Dr. Kilmer usually keeps a spare key to his office somewhere.', 'Dr. Rohrbaugh')),
	retract(text(_, 'Dr. Rohrbaugh')),
	asserta(text('I know Dr. Kilmer usually keeps a spare key to his office somewhere.', 'Dr. Rohrbaugh')).
	
%% if the user has all the pieces of the password, Dr. Rohrbaugh will want to know if the user can figure out
%% the password
puzzle:-
	have('piece 1'),
	have('piece 2'),
	have('piece 3'),
	not(text('So, you found all the pieces. Can you figure out the password?', 'Dr. Rohrbaugh')),
	retract(text(_, 'Dr. Rohrbaugh')),
	asserta(text('So, you found all the pieces. Can you figure out the password?', 'Dr. Rohrbaugh')).

%% if the user tells Dr. Rohrbaugh the password, the game ends.
puzzle:-
	has(password, 'Dr. Rohrbaugh'),
	write('Dr. Rohrbaugh says '), nl,
	tab(2), write('That\'s right! You figured out the password!'), nl,
	tab(2), write('I guess giving Dr. Weaver my password wasn\'t such a good idea.'), nl,
	tab(2), write('I\'ll have to think of some other way to remember my password if I forget it.'), nl,
	tab(2), write('Thank you for your help!'), nl,
	tab(2), write('Oh, you want a reward?'), nl,
	tab(2), write('I\'ll talk to Dr. Owen about giving you one of those Bucky Balls he gives out '), nl,
	tab(2), write('as prizes in his classes. I\'ll put it in your campus mailbox.'), nl,
	tab(2), write('Thanks again for all your help!'), nl, nl,
	tab(2), write('Congrats, You Won!').

%% if the user gives Dr. Owen the pizza, he will stand up and the user
%% can investigate the couch
puzzle:- 
	has(pizza, 'Dr. Owen'),
	retract(text('I\'m just so hungry... Also this couch is very uncomfortable. I may be sitting on something', 'Dr. Owen')),
	retract(blocked(couch)), 
	text(Text, 'Dr. Owen'), nl,
	write('Dr. Owen says '), nl,
	tab(2),
	write(Text),
	nl,
	write('Dr. Owen stood up!'), nl, !. 

%% all the rooms in the game
room('Dr. Weaver\'s office').
room('outside Dr. Weaver\'s office').
room('the faculty lounge').
room('Dr. Rohrbaugh\'s office').
room('outside Dr. Rohrbaugh\'s office').
room('Dr. Kilmer\'s office').
room('outside Dr. Kilmer\'s office').

%% determines if 2 locations are connected
connect(X, Y) :- door(X, Y).
connect(X, Y) :- door(Y,X).

%% doors to link 2 locations
door('Dr. Weaver\'s office', 'outside Dr. Weaver\'s office').
door('Dr. Rohrbaugh\'s office', 'outside Dr. Rohrbaugh\'s office').
door('outside Dr. Kilmer\'s office', 'outside Dr. Rohrbaugh\'s office').
door('outside Dr. Kilmer\'s office', 'outside Dr. Weaver\'s office').
door('outside Dr. Weaver\'s office', 'the faculty lounge').

%% the locations of all the items at the start of the game
location('Dr. Weaver\'s desk', 'Dr. Weaver\'s office').
location('Networking textbook', bookcase).
location('Security textbook', bookcase).
location('WWW textbook', bookcase).
location(bookcase, 'Dr. Weaver\'s office').
location(computer, 'Dr. Weaver\'s office').
location('Dr. Weaver', 'Dr. Weaver\'s office').
location(printer,'the faculty lounge').
location(keurig, 'the faculty lounge').
location(trashcan, 'the faculty lounge').
location(mug, trashcan).
location('Dr. Rohrbaugh\'s desk', 'Dr. Rohrbaugh\'s office').
location(shelf, 'Dr. Rohrbaugh\'s office').
location(pizza, 'the faculty lounge').
location('Dr. Rohrbaugh','Dr. Rohrbaugh\'s office').
location('Dr. Kilmer\'s desk', 'Dr. Kilmer\'s office').
location('locked door', 'outside Dr. Kilmer\'s office').
location(key, doorframe).
location('treasure chest', 'Dr. Kilmer\'s desk').
location(doorframe, 'locked door').
location('piece 3', 'treasure chest').
location('keurig cups', couch).
location('Dr. Owen', 'the faculty lounge'). 
location(couch, 'the faculty lounge').

% the user's starting location
here('Dr. Rohrbaugh\'s office').


% descriptions of objects in the game
description('A kuerig machine for making coffee. Keurig cup and mug required!', keurig).
description('A bookcase full of textbooks', bookcase).
description('Dr. Weaver\'s computer. There\'s something important-looking on the screen but you can\'t read it from here.', computer).
description('Dr. Weaver, master of the world wide web and a professor at the college. He is protecting the password!', 'Dr. Weaver').
description('A printer in the faculty hallway. It can print, scan, and copy', printer).
description('A simple desk with drawers.', 'Dr. Rohrbaugh\'s desk').
description('A simple desk with drawers.', 'Dr. Weaver\'s desk').
description('A simple desk with drawers.', 'Dr. Kilmer\'s desk').
description('The faculty lounge trashcan.', trashcan).
description('A shelf in Dr. Rohrbaugh\'s office.', shelf).
description('A fresh pizza. It looks delicious.', pizza).
description('Dr. Rohrbaugh, the best professor at Messiah College. He always gives good advice.', 'Dr. Rohrbaugh').
description('A fresh cup of coffee.', coffee).
description('A locked door, it has a doorframe', 'locked door').
description('Sometimes people hide keys on top of doorframes in case they forget.', doorframe).
description('A key unlocks important entryways and boxes that hold things', key).
description('A treasure chest holds important items for safe keeping.', 'treasure chest').
description('A piece of the password. It says: bestpa', 'piece 1').
description('A piece of the password. It says: sswor', 'piece 2').
description('A piece of the password. It says: dever123', 'piece 3').
description('A book about Networking', 'Networking textbook').
description('A book about Security', 'Security textbook').
description('A book about the world wide web', 'WWW textbook').
description('A mug for making hot drinks', mug).
description('Cups that can be used with the keurig coffee maker', 'keurig cups').
description('Dr. Owen, a really funny professor who really likes pizza', 'Dr. Owen').
description('A couch in the faculty lounge. People often lose things in this couch', couch).



%% used to check if the room is an "office", used for in-game
%% text purposes
%% i.e. you are [in] Dr. Weaver's office vs you are outside Dr. Weaver's office 
is_office('Dr. Weaver\'s office').
is_office('Dr. Rohrbaugh\'s office').
is_office('the faculty lounge').
is_office('Dr. Kilmer\'s office').

%% used to determine if the user can take an object,
%% the user can't take furniture
furniture(bookcase).
furniture(desk).
furniture(computer).
furniture(printer).
furniture(keurig).
furniture(trashcan). 
furniture('Dr. Weaver\'s desk').
furniture('Dr. Rohrbaugh\'s desk').
furniture('Dr. Kilmer\'s desk').
furniture(shelf).
furniture('locked door').
furniture(doorframe).
furniture('treasure chest').
furniture(couch).

%% determine if something is blocking an object
blocked(couch).

%% used to determine if something is a person
person('Dr. Weaver').
person('Dr. Rohrbaugh').
person('Dr. Owen').

%% text given when using the talk command on a person
text('I sure could use some caffeine before I give my lecture...', 'Dr. Weaver').
text('This is just what I needed! Thanks! Uh oh, I need to get to my class. Please close the door on your way out!', 'Dr. Weaver').
text('You should check in Dr. Weaver\'s office for clues about the password.', 'Dr. Rohrbaugh').
text('I\'m just so hungry... Also this couch is very uncomfortable. I may be sitting on something', 'Dr. Owen').  /**change */
text('This pizza is delicious. May as well stretch my legs', 'Dr. Owen'). /** change*/

%% what a person or object wants/needs for the game to advance
want(pizza, 'Dr. Owen').
want(mug, keurig).
want('keurig cups', keurig).
want('Dr. Weaver\'s key card', printer).

%% the password the user must find
password(bestpasswordever123).

%% the user can't use an item if he or she doesn't have it
use(Item, Receiver):-
	not(have(Item)),
	write('You don\'t have that item!'), nl, !.
%% gives the item to the Receiver if the receiver is a person
use(Item, Receiver):-
	have(Item),
	person(Receiver),
	want(Item, Receiver),
	retract(have(Item)),
	asserta(has(Item, Receiver)),
	write('You gave the '), write(Item),
	write(' to '), write(Receiver), nl, !.
	
%% uses the item on the Receiver if the receiver is not a person
use(Item, Receiver):-
	have(Item),
	not(person(Receiver)),
	want(Item, Receiver),
	retract(have(Item)),
	asserta(has(Item, Receiver)),
	write('You used the '), write(Item),
	write(' on the '), write(Receiver),
	write('.'), nl, !.
	
%% Receiver rejects the item if the receiver is a person
use(Item, Receiver):-
	have(Item),
	person(Receiver),
	not(want(Item, Person)),
	write(Person), write(' says '), nl,
	tab(2), write('I don\'t want that.'), nl, !.
%% Receiver rejects the item if the receiver is not a person
use(Item, Receiver):-
	have(Item),
	not(person(Receiver)),
	not(want(Item, Person)),
	write('You can\'t use that here!'), nl, !.

%% command to look around the area if in an "office"
look :-
	here(Place),
	is_office(Place),
	write('You are in '), write(Place), write('.'), nl,
	write('You see '), nl,
	list_items(Place), nl,
	write('You can go to '), nl,
	list_connections(Place), !.

%% command to look around the area if not in an "office"
look :-
	here(Place),
	not(is_office(Place)),
	write('You are '), write(Place), write('.'), nl,
	write('You see '), nl,
	list_items(Place), nl,
	write('You can go to '), nl,
	list_connections(Place), nl, !.

%% look in something but check if something is blocking the
%% user from doing so
look_in(Thing):- /** change*/
  blocked(Thing),
  write('You can\'t look there is someone in the way'), nl, !. 

%% look in something	
look_in(Thing):-
  location(_,Thing),               % make sure there's at least one
  write('The '),write(Thing),write(' contains:'),nl,
  list_items(Thing).
look_in(Thing):-
  write('There is nothing in the '), write(Thing), nl.

%% list_items default output if nothing is in the area
list_items(Place) :-
	not(location(X, Place)),
	tab(2),
	write('Nothing of interest'),
	nl, !.

%% list items in area
list_items(Place) :-
	location(X, Place),
	tab(2),
	write(X),
	nl,
	fail.
list_items(_).

%% list connections to a place
list_connections(Place) :-
	connect(Place, X),
	tab(2),
	write(X),
	nl,
	fail.
list_connections(_).

%% go to a different area
goto(Place) :- 
	can_go(Place),
	move(Place),
	look.
 
 %% check if the user can go to an area
can_go(Place):-
	here(X),
	connect(X, Place), !.

%% output for if the use tries to go to an invalid area
can_go(Place):-
	write('You can''t get there from here.'), nl,
	fail.

%% moves the user to the new area if the area is valid
move(Place):-
	retract(here(_)),
	asserta(here(Place)).

%% change Dr. Rohrbaugh's text after the first time the user talks to Dr. Weaver
talk(Person):-
	person(Person),
	here(Here),
	location(Person, Here),
	(Person == 'Dr. Weaver'),
	not(want(coffee, 'Dr. Weaver')),
	asserta(want(coffee, 'Dr. Weaver')),
	asserta(text('Dr. Weaver loves coffee. Maybe you can use the keurig in the faculty lounge to make him some.', 'Dr. Rohrbaugh')),
	retract(text('You should check in Dr. Weaver\'s office for clues about the password.', 'Dr. Rohrbaugh')),
	talk(Person), !.
	
%% talk to a person and output their response
talk(Person):-
	person(Person),
	here(Here),
	location(Person, Here),  
	text(X, Person),
	write('You talk to '),
	write(Person), write('.'), nl,
	write(Person),
	write(' says '), nl,
	tab(2),
	write(X),
	nl, nl, !.

%% output message if the person is not in the current area
talk(Person):-
	person(Person),
	here(Here),
	not(location(Person, Here)),
	write(Person), write(' is not here!'), nl, !.
	
%% output message if the person is actually an object
talk(Person):-
	write('You can\'t talk to the '),
	write(Person),
	nl, nl.

%% command to tell Dr. Rohrbaugh the password
tell(Person, Phrase):-
	person(Person),
	here(Here),
	location(Person, Here),
	password(X),
	(Person == 'Dr. Rohrbaugh'),
	(Phrase == X),
	asserta(has(password, 'Dr. Rohrbaugh')),
	write('You say '), write(Phrase), write(' to '),
	write(Person), write('.'), nl, !.
	
%% Command to output message if Dr. Rohrbaugh is told an
%% incorrect password
tell(Person, Phrase):-
	person(Person),
	here(Here),
	location(Person, Here),
	password(X),
	(Person == 'Dr. Rohrbaugh'),
	not((Phrase == X)),
	write('You say '), write(Phrase), write(' to '),
	write(Person), write('.'), nl,
	write(Person), write(' says'), nl,
	tab(2), write('That\'s nice but it\'s not the password'), nl, !.
	
%% code when saying anything to a person other than Dr. Rohrbaugh
tell(Person, Phrase):-
	person(Person),
	here(Here),
	location(Person, Here),
	not((Person == 'Dr. Rohrbaugh')),
	text(Y, Person),
	write('You say '), write(Phrase), write(' to '),
	write(Person), write('.'), nl,
	write(Person), write(' says'), nl,
	tab(2), write('I\'m not sure what you\'re talking about but '),
	write(Y), nl, !.

%% output message when trying to talk to a person who isn't in the area
tell(Person, Phrase):-
	person(Person),
	here(Here),
	not(location(Person, Here)),
	write(Person), write(' is not here!'), nl, !.
	
%% output message when trying to talk to an object
tell(Person, Phrase):-
	write('You can\'t talk to the '),
	write(Person),
	nl, !.
	
%% special examine command when examining the computer in
%% Dr. Weaver's office
examine(Thing):-
	here('Dr. Weaver\'s office'),
	location('Dr. Weaver', away),
	(Thing == computer),
	description(X, Thing),
	write(X), nl,
	write('It says'), nl,
	tab(2),
	write('Reminder to self:'), nl,
	tab(2),
	write('I divided Dr. Rohrbaugh\'s password into three parts and hid the pieces in safe places.'), nl,
	tab(2),
	write('One is in a textbook on my bookcase.'),nl,
	tab(2),
	write('I asked Dr. Kilmer to hide the other one.'), nl,
	tab(2),
	write('I sent the last piece to the printer. I need to remember to print it after my class.'), nl, !.

%% examine nested object
examine(Thing):-
	here(Here),
	location(Thing, Here),
	description(X, Thing),
	write(X), nl, !.
%% examine doubly nested object
examine(Thing):-
	here(Here),
	location(Thing, Outter),
	location(Outter, Here),
	description(X, Thing),
	write(X), nl, !.
%% examine object in inventory
examine(Thing):-
	have(Thing),
	description(X, Thing),
	write(X), nl, !.
%% can't examine item
examine(Thing):-
	write('You can\'t examine that.'), nl.

%% code to list items in inventory
inventory :-
	have(X),
	write('You have '), nl,
	not(list_possessions),
	 nl, !.
%% code to output message if the user has no items
inventory :-
	not(have(X)),
	write('You do not have any items.'), nl, !.

%% list items
list_possessions:-
	have(X),
	tab(2), write(X), nl,
	fail.
list_possessions(_).

%% determine if an object can be taken
takable(Thing):-
	not(furniture(Thing)),
	not(blocked(Thing)),
	not(person(Thing)).
 
%% unlock Dr. Kilmer's door if picking up the key
take(X):-
	(X == key),
	can_take(X),
    take_object(X), 
    retract(location('locked door', 'outside Dr. Kilmer\'s office')),
    write(X), write(' taken '), nl,
    write('You can now go inside Dr. Kilmer\'s office!'), nl,
    asserta(door('Dr. Kilmer\'s office', 'outside Dr. Kilmer\'s office')), !.
    
%% pick up an object if it can be picked up
take(X):-
	can_take(X),
	take_object(X),
	write(X), write(' taken '),nl, !.

%% determine if an object can be taken
can_take(Thing) :-
	here(Place),
	location(Thing, Place),
	takable(Thing), !.
%% determine if a nested object can be taken
can_take(Thing) :-
	here(Place),
	location(Thing, X),
	location(X, Place),
	takable(Thing), !.
	
%% determine if a doubly nested object can be taken
can_take(Thing) :-
	here(Place),
	location(Thing, X),
	location(X, Y),
	location(Y, Place),
	takable(Thing), !. 
	
%% output message if an object cannot be taken
can_take(Thing) :- 
	here(Place),
	location(Thing, Place),
	not(takable(Thing)),
	write('You can\'t take '),
	write(Thing), nl, !, fail.
	
%% output message if the object is not in the area
can_take(Thing) :-
	write('There is no '), write(Thing),
	write(' here.'),
	nl, fail.

%% code to place object in inventory
take_object(X):-
	retract(location(X,_)),
	asserta(have(X)), nl.
	
%% testing code for teleporting
teleport(Place) :- 
	write('Helooooo'),
	shortcut(Place, X),
	move(X),
	look, !.
	
teleport(Place) :- 
	write('Don\'t be silly... Teleportation is impossible.'), nl,
	fail. 

%% do the appropriate command after getting input
do(goto(X)):-goto(X), !.
do(inventory):-inventory, !.
do(take(X)):-take(X),!.
do(look):-look, !.
do(examine(X)):-examine(X), !.
do(talk(X)):-talk(X),!.
do(look_in(X)):-look_in(X),!.
do(use(X, Y)):-use(X, Y), !.
do(tell(X, Y)):-tell(X,Y), !. 
do(quit):- quit, !.
do(help):- help, !.
do(commands):- commands, !.
do(shortcuts):- shortcuts, !.
do(teleport(X)):-teleport(X), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code to get input commands and process them
% modified from the nani search example code
% at http://www.amzi.com/AdventureInProlog/appendix.php

%% code to get start command at the beginning of the game
get_start(C):-
	read_list(L),
	command(X,L,[]),
	C =.. X, !.
%% output message if a command other than start is given
get_start(_):-
	nl,
	write('Type start to continue'), nl, fail.

%% get a command from input
get_command(C):-
	read_list(L),
	command(X,L,[]),
	C =.. X, !.
get_command(_):-
	write('incorrect command, try again or type help'), nl, fail.

%% determine correct way to parse input
command([Pred,Arg]) --> verb(Type,Pred),nounphrase(Type,Arg).
command([Pred, Arg1, Arg2]) --> verb(Type, Pred), nounphrase(Type, Arg1), nounphrase(Type, Arg2).
command([Pred]) --> verb(intran, Pred).
command([goto,Arg]) --> noun(go_place,Arg).

verb(go_place,goto) --> go_verb.
verb(thing,V) --> tran_verb(V).
verb(intran,V) --> intran_verb(V).

go_verb --> [go].
go_verb --> [go,to].
go_verb --> [g].
go_verb --> [go, in].
go_verb --> [go, inside].
 
tran_verb(take) --> [take].
tran_verb(tell) --> [tell].
tran_verb(take) --> [pick,up].
tran_verb(talk) --> [talk, to].
tran_verb(talk) --> [talk].
tran_verb(look_in) --> [look, in].
tran_verb(examine) --> [examine].
tran_verb(use) --> [give].
tran_verb(use) --> [use].
tran_verb(teleport) --> [teleport].

intran_verb(start) --> [start].
intran_verb(start) --> ['Start'].
intran_verb(inventory) --> [inventory].
intran_verb(look) --> [look].
intran_verb(look) --> [look,around].
intran_verb(shortcuts) --> [shortcuts].
intran_verb(help) --> [help].
intran_verb(quit) --> [quit].
intran_verb(commands) --> [commands].
 
nounphrase(Type,Noun) --> det,noun(Type,Noun).
nounphrase(Type,Noun) --> noun(Type, Noun).
nounphrase(Type,Noun) --> prep, det, noun(Type, Noun).
nounphrase(Type, Noun) --> prep, noun(Type, Noun).
 
det --> [the].
det --> [a].
 
prep --> [to].
prep --> [on].

noun(go_place,R) --> [R], {room(R)}.
noun(go_place,'Dr. Weaver\'s office') --> ['Dr','Weaver', s, office].
noun(go_place,'outside Dr. Weaver\'s office') --> [outside, 'Dr', 'Weaver', s, office].
noun(go_place,'Dr. Kilmer\'s office') --> ['Dr','Kilmer', s, office].
noun(go_place,'outside Dr. Kilmer\'s office') --> [outside, 'Dr', 'Kilmer', s, office].
noun(go_place,'Dr. Rohrbaugh\'s office') --> ['Dr','Rohrbaugh', s, office].
noun(go_place,'outside Dr. Rohrbaugh\'s office') --> [outside, 'Dr', 'Rohrbaugh', s, office].
noun(go_place,'Dr. Weaver\'s office') --> [office], {here('outside Dr. Weaver\'s office')}.
noun(go_place,'outside Dr. Weaver\'s office') --> [outside], {here('Dr. Weaver\'s office')}.
noun(go_place,'Dr. Kilmer\'s office') --> [office], {here('outside Dr. Kilmer\'s office')}.
noun(go_place,'outside Dr. Kilmer\'s office') --> [outside], {here('Dr. Kilmer\'s office')}.
noun(go_place,'Dr. Rohrbaugh\'s office') --> [office], {here('outside Dr. Rohrbaugh\'s office')}.
noun(go_place,'outside Dr. Rohrbaugh\'s office') --> [outside], {here('Dr. Rohrbaugh\'s office')}.
noun(go_place, 'the faculty lounge') --> [the, faculty, lounge].
noun(go_place, 'outside Dr. Weaver\'s office') --> [outside], {here('the faculty lounge')}.
noun(go_place, 'the faculty lounge') --> [faculty, lounge].
noun(go_place, 'Dr. Rohrbaugh\'s office') --> [dro].
noun(go_place, 'outside Dr. Rohrbaugh\'s office') --> [outside, dro].
noun(go_place, 'outside Dr. Rohrbaugh\'s office') --> [odro].
noun(go_place, 'Dr. Weaver\'s office') --> [dwo].
noun(go_place, 'outside Dr. Weaver\'s office') --> [outside, dwo].
noun(go_place, 'outside Dr. Weaver\'s office') --> [odwo].
noun(go_place, 'Dr. Kilmer\'s office') --> [dko].
noun(go_place, 'outside Dr. Kilmer\'s office') --> [outside, dko].
noun(go_place, 'outside Dr. Kilmer\'s office') --> [odko].
noun(go_place, 'the faculty lounge') --> [tfl].

noun(thing, 'Dr. Weaver') --> ['Dr', 'Weaver'].
noun(thing, 'Dr. Weaver') --> [dw].
noun(thing, 'Dr. Rohrbaugh') --> ['Dr', 'Rohrbaugh'].
noun(thing, 'Dr. Rohrbaugh') --> [dr].
noun(thing, 'Dr. Owen') --> ['Dr', 'Owen'].
noun(thing, 'Dr. Owen') --> [do].
noun(thing, 'keurig cups') --> [keurig, cups].
noun(thing, 'locked door') --> [locked, door].
noun(thing, 'treasure chest') --> [treasure, chest].
noun(thing, 'Networking textbook') --> ['Networking', textbook].
noun(thing, 'Security textbook') --> ['Security', textbook].
noun(thing, 'WWW textbook') --> ['WWW', textbook].
noun(thing, 'Dr. Weaver\'s desk') --> [desk], {here('Dr. Weaver\'s office')}.
noun(thing, 'Dr. Kilmer\'s desk') --> [desk], {here('Dr. Kilmer\'s office')}.
noun(thing, 'Dr. Rohrbaugh\'s desk') --> [desk], {here('Dr. Rohrbaugh\'s office')}.
noun(thing, 'Dr. Kilmer\'s desk') --> ['Dr', 'Kilmer', s, desk].
noun(thing, 'Dr. Rohrbaugh\'s desk') --> ['Dr', 'Rohrbaugh', s, desk].
noun(thing, 'Dr. Weaver\'s desk') --> ['Dr', 'Weaver', s, desk].
noun(thing, 'Dr. Weaver\'s key card') --> ['Dr', 'Weaver', s, key , card].
noun(thing, 'Dr. Weaver\'s key card') --> [key, card].
noun(thing, 'piece 3') --> [piece, 3].
noun(thing, 'piece 2') --> [piece, 2].
noun(thing, 'piece 1') --> [piece, 1].
noun(thing,T) --> [T], {location(T,_)}. 
noun(thing, T) --> [T], {have(T)}.
noun(thing, T) --> [T].

% read a line of words from the user
% taken from example code in figure 15.2 at 
% http://www.amzi.com/AdventureInProlog/a15nlang.php

read_list(L) :-
  write('> '),
  read_line(CL),
  wordlist(L,CL,[]), !.

read_line(L) :-
  get0(C),
  buildlist(C,L).

buildlist(10,[]) :- !.
buildlist(C,[C|X]) :-
  get0(C2),
  buildlist(C2,X).
  
wordlist([X|Y]) --> word(X), whitespace, wordlist(Y).
wordlist([X]) --> whitespace, wordlist(X).
wordlist([X]) --> word(X).
wordlist([X]) --> word(X), whitespace.

word(W) --> charlist(X), {name(W,X)}.

charlist([X|Y]) --> chr(X), charlist(Y).
charlist([X]) --> chr(X).

chr(X) --> [X],{X>=48}.

whitespace --> whsp, whitespace.
whitespace --> whsp.

whsp --> [X], {X<48}.