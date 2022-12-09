### Task 1 ###
# Create a variable of the type:

#Int64
# name it "intvar"

#Float64
# name it "floatvar"

#String
# name it "stringvar"

#Symbol
# name it "symbolvar"

#Bool
# name it "boolvar"


### Task 2 ###
#2.1 Create two variables of type String with the content:

# "Hello"

# and "World!"

#2.2 Concatenate these two variables with a space in between
# Hint: Take a look at the official Julia doc if you do not know how to do it
# https://docs.julialang.org/en/v1/manual/strings/#man-concatenation


#2.3 Use string interpolation to create a sentence
# using at least three of the variables created in task 1!
# Hint: Take a look at https://docs.julialang.org/en/v1/manual/strings/#string-interpolation
# Assign this sentence as a String to a variable called "mymeaningfulsentence"

#2.4 Print the variable "mymeaningfulsentence" to the REPL!


### Task 3 ###
#3.1 Create an array with the size 100x100 that contains only zeros of type Float64.
# Assing it to the variable name "mymatrix"

#3.2 Use the "fill!" function to replace the values of "mymatrix" with the value 1.

#3.3 Sum up all values of "mymatrix" and print the result to the REPL.

#3.4 Select only the last row of "mymatrix" and print it to the REPL.
# Hint: Indexing in Julia is row first, column second. You can use the colon ":" operator
# to select every position in a dimension of an array.
# If you have troube with indexing of arrays, take a look at https://juliabook.chkwon.net/book/basics#cid15

#3.4 Create a vector of the length 100 which contains the numbers 2 to 200 in steps of 2.

#3.5 Replace the last row of "mymatrix" with the vector created in task 3.4 and print "mymatrix"
# to the REPL

#3.6 Create another vector of the length 100 containing random numbers and use
# the function "hcat" to concatenate this vector to "mymatrix".
# This new array should be assigned to the variable name "mergedarray"

#3.7 Print the size of "mergedarray" to the REPL.

#3.8 Sum over the first dimension of "mergedarray" and print the result to the REPL.


### Task 4 ###
# 4.1 Create a dictionary which takes the type Int64 as keys and Float64 as values.
# Name it "mydict".
# Hint: You can force element type of dictionaries using "Dict{T1,T2}()" where T1 and T2
# are the respective types you want to specify.


# 4.2 Add the an entry with key 1 and value 10.

# 4.3 Iterate from 1 to 5 using a for-loop and assign the iteration counter as key
# with a random number as value. Afterwards, print the dictionary to the REPL.

# 4.4 Create a Vector that containts all values from the dictionary which are greater
# than 0.5.
