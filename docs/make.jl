using Documenter, PythonToJuliaHelper

makedocs(;
    modules=[PythonToJuliaHelper],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/diegozea/PythonToJuliaHelper.jl/blob/{commit}{path}#L{line}",
    sitename="PythonToJuliaHelper.jl",
    authors="Diego Javier Zea",
    assets=[],
)

deploydocs(;
    repo="github.com/diegozea/PythonToJuliaHelper.jl",
)
