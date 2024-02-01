There is a plugin called *Numerals* installed that will allow you to carry out calculations inside an Obsidian note.  Create a codeblock that starts with three tick-marks (to the right of the "1" key) and the word *math*.  End the codeblock with three tick marks.  Anything between the tick marks will be viewed as a calculations

```math
my_variable = 10
another_variable = pi
my_result = my_variable*another_variable
```

To edit a code-block, mouse over and click the "</>" symbol to reveal the code.
```math
a=2
b=8
a^b
```
Autocomplete seems a bit wonky because I had trouble getting just *pi*.  A good way to check whether a system uses degrees or radians is to calculate the sine and/or cosine of 90 and $\pi/2$.  Whichever results gives you 0 and 1 tells you the system used.  Below you can see this is using radians.

```math
log(e)
log2(e)
cos(90)
sin(90)

cos(pi/2)
sin(pi/2)
```