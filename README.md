# m2-5

This is a translation of Markusen's M2-5 model available here (maximize utility, 1 good, 1 factor, 1 consumer): https://spot.colorado.edu/~markusen/teaching_files/applied_general_equilibrium/GAMS/0312_Examplesgms/M2-5.gms.  This example shows how to set @NLparameters and fixing/unfixing decision variables, in order to change the model structure between multiple solves.  This model has 4 solve statements back to back.

The .gms file is provided for GAMS users and a translated version of the .gms file is provided in Julia/JuMP format (.jl).  Data from the .gms file is output to a GDX container and then converted into a JSON file with gdx2json.py.  The Julia/JuMP model then reads the data directly in from the JSON file.

In order to run the gdx2json.py script the user will need to install the GAMS Python API (https://www.gams.com/latest/docs/API_PY_OVERVIEW.html)... and may need to create a Python 3 environment with the following .yml file.  Conda was used as the Python package manager and is recommended to create this environment.  Information on how to import this environment is available here: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#sharing-an-environment

The solution between the GAMS model and the Julia/JuMP model has been verified to be the same.


# Requirements
Python 3 (see .yml for exact environment), GAMS Python API, Julia 1.1.0 (JuMP, JSON, and Ipopt packages)


# Use
To recreate the original data GDX container and the JSON file that is used to populate the .jl file simply run
```
gams m2-5.gms
```

To execute the Julia/JuMP model with the existing JSON file simply run
```
julia m2-5.jl
```
