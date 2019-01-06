using PythonToJuliaHelper
using Test

const python_example = split("""
def absolute_value(num):
    \"\"\"This function takes a number and returns
    its absolute value.

    >>> absolute_value(-10)
    10
    \"\"\"
    if num >= 0: # Positive or zero
        return num
    else: # Negative
        return -num

def say_hi():
    "It says Hi!"
    print("Hi!")

def say_bye():
    print(
    "Bye!"
    )

x = lambda a, b : a * b

if True:
    print("True")

if False:
    print("False")

for i in xrange(10):
    print(x(i, i))
""", '\n')

const julia_example = split("""
\"\"\"This function takes a number and returns
its absolute value.

julia> absolute_value(-10)
10
\"\"\"
function absolute_value(num)
    if num >= 0 # Positive or zero
        return num
    else # Negative
        return -num
    end
end

"It says Hi!"
function say_hi()
    println("Hi!")
end

function say_bye()
    println(
    "Bye!"
    )
end

x = (a, b) -> a * b

if true
    println("true")
end

if false
    println("false")
end

for i in 0:10
    println(x(i, i))
end
""", '\n')

@testset "PythonToJuliaHelper.jl" begin

    @test PythonToJuliaHelper.add_end_to_block!(copy(python_example), 1)[12]  == "end"
    @test PythonToJuliaHelper.add_end_to_block!(copy(python_example), 8)[12]  == "    end"
    @test PythonToJuliaHelper.add_end_to_block!(copy(python_example), 30)[32] == "end"

    @test PythonToJuliaHelper.delete_colon!(copy(python_example), 1)[1] == "def absolute_value(num)"
    @test PythonToJuliaHelper.delete_colon!(copy(python_example), 8)[8] == "    if num >= 0 # Positive or zero"
    @test PythonToJuliaHelper.delete_colon!(copy(python_example), 22)[22] == "x = lambda a, b : a * b"
    @test PythonToJuliaHelper.delete_colon!(copy(python_example), 30)[30] == "for i in xrange(10)"

    @test PythonToJuliaHelper.function_docstrings(python_example, 1)[1] == "\"\"\"This function takes a number and returns"
    @test PythonToJuliaHelper.function_docstrings(python_example, 13)[13] == "\"It says Hi!\""
    @test PythonToJuliaHelper.function_docstrings(python_example, 17)[17] == "def say_bye():"

    @test python2julia(python_example) == julia_example

    @test python2julia("example.py") == readlines("example.jl") == string.(split("""
    "docstring"
    function function_name(arg)
        for value in 0:arg
            if value > 3
                return true
            elseif value < 4
                return nothing
            else
                return false
            end
        end
    end""", '\n'))
end
