[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=6912000&assignment_repo_type=AssignmentRepo)
# A2: Word Counter

### Learning Outcomes
1. **Write** a simple Zig program to parse a file.
1. **Use** a data structure from the Zig standard library appropriate for the task.
1. **Use** a memory allocator.

### Specifications

For this assignment, you will complete a program that counts the number of words in a file. This is similar to the common Linux tool `wc` (word count). In fact, you can check that your program is functioning correctly by running `wc -w` on the provided corpus files. The only difference is that we will output the words and their associated counts (for words that appear twice or more times in the source text).

### Using A Memory Allocator

One of these has been chosen for you here.

### Using a stdlib Data Structure

We need a data structure where each word is associated with its count. This is a good opportunity to use a *hash map* where each key is the word and the value is the number of times it occurs in the file.

### Example

Here's a sample interaction with a working program. *Your program must not print out anything other than what's shown or the autograder will fail*. The `$` character represents the terminal prompt, you do not type this character when executing commands.

```
$ zig run src/main.zig -- msno.txt
MissingNo. 23
for 6
and 35
the 92
is 11
an 12
Pokemon 29
species 2
in 29
video 5
games 7
Red 5
Due 2
to 40
of 41
certain 2
in-game 4
players 10
can 8
encounter 7
a 32
glitch. 2
graphical 3
by 12
increasing 2
number 2
items 2
sixth 2
player's 4
inventory 2
glitch's 2
guides 2
game 12
Nintendo 5
warned 3
that 20
encountering 3
glitch 5
may 4
IGN 2
MissingNo.'s 3
Blue 4
was 5
one 3
most 2
glitches 4
commented 2
on 9
its 5
role 2
Fans 2
have 6
attempted 2
incorporate 2
as 22
part 2
games' 2
actual 2
== 10
Game 5
series 2
with 11
In 4
these 2
player 10
goal 2
capture 3
creatures 2
Pokemon. 2
abilities 2
other 2
Pokemon, 3
also 3
game's 7
such 4
travel 3
The 5
from 6
not 6
are 2
but 2
it 7
events 2
appear 2
could 2
your 2
or 4
remove 2
several 2
games. 2
Viridian 2
City 2
location. 2
uses 2
move 2
Cinnabar 3
Island 2
up 2
generate 2
invalid 2
area 2
within 2
data 4
be 5
encountered 2
area. 2
this 4
used 2
tutorial, 2
character's 4
name 4
temporarily 2
read 3
same 2
viewing 2
being 3
appears 2
even 2
cut 2
commonly 2
how 2
game, 2
article, 3
helped 2
book 3
MissingNo[.] 2
his 3
Wilma 2
Bainbridge, 2
then 2
2019 2
Ars 2
at 2
belief 2
professor 2
world 2
fan 2
theories 2
related 2
Explained 2
- 2

./msno.txt 1274
```
