var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#PythonToJuliaHelper.PYTHON2JULIA_WORDS",
    "page": "Home",
    "title": "PythonToJuliaHelper.PYTHON2JULIA_WORDS",
    "category": "constant",
    "text": "List of Pairs to replace Python\'s words by Julia\'s words. In the Regex,  indicates a word boundary.\n\n\n\n\n\n"
},

{
    "location": "#PythonToJuliaHelper.python2julia-Tuple{Any}",
    "page": "Home",
    "title": "PythonToJuliaHelper.python2julia",
    "category": "method",
    "text": "It takes Python code lines and transform it to something closer to Julia code.\n\nIt moves docstrings before their function definitions.\nIt adds an end line to for, if and function blocks.\nIt deletes colons at the end of for, if, def, else and elif statements.\nIt changes anonymous function syntax.\nIt changes (x)range syntax without modification of the values.\nIt replaces python words using the pairs in PYTHON2JULIA_WORDS.\n\n\n\n\n\n"
},

{
    "location": "#PythonToJuliaHelper.add_end_to_block!-Tuple{Any,Any}",
    "page": "Home",
    "title": "PythonToJuliaHelper.add_end_to_block!",
    "category": "method",
    "text": "It adds an end line at the end of an indented block.\n\n\n\n\n\n"
},

{
    "location": "#PythonToJuliaHelper.anonymous_function-Tuple{Any}",
    "page": "Home",
    "title": "PythonToJuliaHelper.anonymous_function",
    "category": "method",
    "text": "Python | lambda x, y : y + x * 2 Julia  | (x,y) -> y + x * 2\n\njulia> using PythonToJuliaHelper\n\njulia> PythonToJuliaHelper.anonymous_function(\"lambda x, y : y + x * 2\")\n\"(x, y) -> y + x * 2\"\n\njulia> PythonToJuliaHelper.anonymous_function(\"lambda x : x * 2\")\n\"x -> x * 2\"\n\n\n\n\n\n\n"
},

{
    "location": "#PythonToJuliaHelper.delete_colon!-Tuple{Any,Any}",
    "page": "Home",
    "title": "PythonToJuliaHelper.delete_colon!",
    "category": "method",
    "text": "It deletes the colon at the end of the line.\n\n\n\n\n\n"
},

{
    "location": "#PythonToJuliaHelper.function_docstrings-Tuple{Any,Any}",
    "page": "Home",
    "title": "PythonToJuliaHelper.function_docstrings",
    "category": "method",
    "text": "It moves the docstring before the function definition.\n\n\n\n\n\n"
},

{
    "location": "#PythonToJuliaHelper.get_indentation-Tuple{Any}",
    "page": "Home",
    "title": "PythonToJuliaHelper.get_indentation",
    "category": "method",
    "text": "Return the indentation of the line.\n\njulia> using PythonToJuliaHelper\n\njulia> PythonToJuliaHelper.get_indentation(\"        if value:\")\n\"        \"\n\njulia> PythonToJuliaHelper.get_indentation(\"def fun(arg):\")\n\"\"\n\n\n\n\n\n\n"
},

{
    "location": "#PythonToJuliaHelper.move_all_docstrings-Tuple{Any}",
    "page": "Home",
    "title": "PythonToJuliaHelper.move_all_docstrings",
    "category": "method",
    "text": "It moves all the docstrings before their function definitions.\n\n\n\n\n\n"
},

{
    "location": "#PythonToJuliaHelper.ranges-Tuple{Any}",
    "page": "Home",
    "title": "PythonToJuliaHelper.ranges",
    "category": "method",
    "text": "Python | range(stop) Python | range(start, stop) Python | range(start, stop, step) Julia  | start:stop Julia  | start:step:stop\n\nPython\'s range(3) and range(0, 3) (i.e. 0,1,2) are going to be Julia\'s 0:3 (i.e. 0,1,2,3)\n\nPython\'s range and xrange are translated to ranges unless collect=true.\n\njulia> using PythonToJuliaHelper\n\njulia> PythonToJuliaHelper.ranges(\"range(stop)\")\n\"0:stop\"\n\njulia> PythonToJuliaHelper.ranges(\"range(start, stop)\")\n\"start:stop\"\n\njulia> PythonToJuliaHelper.ranges(\"range(start,stop,step)\")\n\"start:step:stop\"\n\njulia> PythonToJuliaHelper.ranges(\"range(start,stop,step)\", collect=true)\n\"collect(start:step:stop)\"\n\njulia> PythonToJuliaHelper.ranges(\"xrange(start,stop,step)\", collect=true)\n\"start:step:stop\"\n\n\n\n\n\n\n"
},

{
    "location": "#PythonToJuliaHelper.jl-1",
    "page": "Home",
    "title": "PythonToJuliaHelper.jl",
    "category": "section",
    "text": "Modules = [PythonToJuliaHelper]"
},

]}
