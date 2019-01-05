module PythonToJuliaHelper

export  PYTHON2JULIA_WORDS,
        python2julia

"""
List of `Pair`s to `replace` Python's words by Julia's words.
In the Regex, `\b` indicates a word boundary.
"""
const PYTHON2JULIA_WORDS = Pair{Regex, String}[
    # Regex: \b indicates a word boundary
    r"\bNone\b"    => "nothing",
    r"\bTrue\b"    => "true",
    r"\bFalse\b"   => "false",
    r"\btype\b\("  => "typeof(",
    r"\bid\b\("    => "object_id(",
    r"\blen\b\("   => "length(",
    r"\bprint\b\(" => "println(",
    r"\bdef\b"     => "function",
    r"\belif\b"    => "elseif",
    r">>>"         => "julia>"
    ]

"""
Return the indentation of the line.

```jldoctest
julia> get_indentation("        if value:")
"        "

julia> get_indentation("def fun(arg):")
""

```
"""
function get_indentation(line)
    m = match(r"^(\s+).", line)
    if m !== nothing
        return m[1]
    else
        return ""
    end
end

"It adds an `end` line at the end of an indented block."
function add_end_to_block!(lines, start_position)
    position = start_position
    look_for_indentation = false
    block_indentation = nothing
    end_indentation = get_indentation(lines[start_position])
    non_empty_lines = Int[]
    while position ≤ length(lines)
        line = lines[position]
        if length(strip(line)) == 0
            position += 1
            continue
        else
            push!(non_empty_lines, position)
        end
        if block_indentation === nothing && match(r"\:\s*(#.+)?$", line) !== nothing
            look_for_indentation = true
            position += 1
            continue
        end
        if look_for_indentation
            block_indentation = get_indentation(line)
            look_for_indentation = false
        end
        if block_indentation !== nothing
            line_indentation = get_indentation(line)
            if length(line_indentation) < length(block_indentation)
                if match(r"^\s*else\s*\:\s*(#.+)?$", line) === nothing &&
                   match(r"^\s*elif\s+.*\:\s*(#.+)?$", line) === nothing

                    insert!(lines, non_empty_lines[end-1]+1,
                            string(end_indentation, "end"))
                    block_indentation = nothing
                    break
                end
            end
        end
        position += 1
    end
    if block_indentation !== nothing
        insert!(lines, non_empty_lines[end]+1, string(end_indentation, "end"))
    end
    lines
end

"It deletes the colon at the end of the line."
function delete_colon!(lines, start_position)
    position = start_position
    while position ≤ length(lines)
        line = lines[position]
        if match(r"\:\s*(#.+)?$", line) !== nothing
            lines[position] = replace(line, r"\:(\s*(#.+)?)$" => s"\1")
            break
        end
        position += 1
    end
    lines
end

"""
Python | lambda x, y : y + x * 2
Julia  | (x,y) -> y + x * 2

```julia
julia> anonymous_function("lambda x, y : y + x * 2")
"(x, y) -> y + x * 2"

julia> anonymous_function("lambda x : x * 2")
"x -> x * 2"

```
"""
function anonymous_function(line)
    m = match(r"lambda\s+(.+)\s*\:\s*", line)
    if m !== nothing
        python_args = rstrip(m.captures[1])
        julia_args = occursin(',', python_args) ? string("(", python_args, ")") : python_args
        line = replace(line, m.match => string(julia_args, " -> "))
    end
    line
end

"""
Python | range(stop)
Python | range(start, stop)
Python | range(start, stop, step)
Julia  | start:stop
Julia  | start:step:stop

Python's `range(3)` and `range(0, 3)` (i.e. 0,1,2) are going to be Julia's `0:3` (i.e. 0,1,2,3)

Python's `range` and `xrange` are translated to ranges unless `collect=true`.

```julia
julia> ranges("range(stop)")
"0:stop"

julia> ranges("range(start, stop)")
"start:stop"

julia> ranges("range(start,stop,step)")
"start:step:stop"

julia> ranges("range(start,stop,step)", collect=true)
"collect(start:step:stop)"

julia> ranges("xrange(start,stop,step)", collect=true)
"start:step:stop"

```
"""
function ranges(line; collect::Bool=false)
    m = match(r"\bx?range\b\((.*)\)", line)
    if m !== nothing
        if collect && !occursin("xrange", m.match)
            prefix = "collect("
            suffix = ")"
        else
            prefix = ""
            suffix = ""
        end
        python_args = [ strip(arg) for arg in split(m.captures[1], ',') ]
        n_args = length(python_args)
        if n_args == 1
            line = replace(line, m.match => "$(prefix)0:$(python_args[1])$(suffix)")
        elseif n_args == 2
            line = replace(line, m.match => "$(prefix)$(python_args[1]):$(python_args[2])$(suffix)")
        elseif n_args == 3
            line = replace(line, m.match => "$(prefix)$(python_args[1]):$(python_args[3]):$(python_args[2])$(suffix)")
        end
    end
    line
end

"It moves the docstring before the function definition."
function function_docstrings(lines, start_position)
    position = start_position
    docstring_lines = Int[]
    started = false
    ended = false
    look_for_docstring = false
    while position ≤ length(lines)
        line = lines[position]
        if match(r"\:\s*(#.+)?$", line) !== nothing
            look_for_docstring = true
            position += 1
            continue
        end
        if look_for_docstring && !started
            if match(r"^\s*\"\"\"", line) !== nothing
                started = true
            elseif match(r"^\s*\"", line) !== nothing
                started = true
                if match(r"\"\s*(#.+)?$", line) !== nothing
                    ended = true
                else
                    break
                end
            elseif match(r"\S+", line) !== nothing
                break
            end
        end
        if started && match(r"\"\"\"\s*(#.+)?$", line) !== nothing
            ended = true
        end
        if started && !ended
            push!(docstring_lines, position)
        elseif started && ended
            push!(docstring_lines, position)
            docs = lines[docstring_lines]
            min_indentation = get_indentation(docs[1])
            for line in docs
                line_indentation = get_indentation(line)
                if length(strip(line)) > 0 && length(line_indentation) < length(min_indentation)
                    min_indentation = line_indentation
                end
            end
            docs = [ replace(line, min_indentation => "", count=1) for line in docs ]
            lines = vcat(
                lines[1:start_position-1],
                docs,
                lines[setdiff(start_position:length(lines), docstring_lines)]
                )
            break
        end
        position += 1
    end
    lines
end

"It moves all the docstrings before their function definitions."
function move_all_docstrings(lines)
    position = 1
    while position < length(lines)
        if match(r"^\s*def\s*", lines[position]) !== nothing
            lines = function_docstrings(lines, position)
        end
        position += 1
    end
    lines
end

"""
It takes Python code lines and transform it to something closer to Julia code.

1. It moves docstrings before their function definitions.
2. It adds an end line to for, if and function blocks.
3. It deletes colons at the end of for, if, def, else and elif statements.
4. It changes anonymous function syntax.
5. It changes (x)range syntax without modification of the values.
6. It replaces python words using the pairs in `PYTHON2JULIA_WORDS`.
"""
function python2julia(lines; collect::Bool=false)
    lines = move_all_docstrings(lines)
    position = 1
    while position < length(lines)
        if (match(r"^\s*if\s*", lines[position]) !== nothing) ||
                (match(r"^\s*for\s*", lines[position]) !== nothing) ||
                (match(r"^\s*def\s*", lines[position]) !== nothing)

            add_end_to_block!(lines, position)
            delete_colon!(lines, position)
        end
        if (match(r"^\s*else\s*\:\s*(#.+)?$", lines[position]) !== nothing) ||
                (match(r"^\s*elif\s+.*\:\s*(#.+)?$", lines[position]) !== nothing)
            delete_colon!(lines, position)
        end
        lines[position] = anonymous_function(lines[position])
        lines[position] = ranges(lines[position], collect=collect)
        for pair in PYTHON2JULIA_WORDS
            lines[position] = replace(lines[position], pair)
        end
        position += 1
    end
    lines
end

function python2julia(filename_input::String,
        filename_output::String = replace(filename_input, r"\.py$" => ".jl");
        kargs...)

    lines = python2julia(readlines(filename_input); kargs...)
    open(filename_output, "w") do fh
        for line in lines
            println(fh, line)
        end
    end
    lines
end

end # module
