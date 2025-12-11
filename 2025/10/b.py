import sys
import re 
from ortools.linear_solver import pywraplp


def toint(str):
    return [int(v) for v in str.split(',')]

def convert(buttons, sz):
    a = []
    for i in range(0, sz):
        v = [0] * len(buttons)
        for j in range(0, len(buttons)):
            if i in buttons[j]:
                v[j] = 1
        a.append(v)
    return a

    

input = sys.argv[1]
with open(input) as f:
    lines = f.read()
    

def solve_smallest_integer_system(A, b):
    # 1. Declare the solver
    # Use 'SCIP' or 'CBC' for Mixed Integer Programming (MIP) problems
    solver = pywraplp.Solver.CreateSolver('SCIP') 
    if not solver:
        print("Solver not available.")
        return

    infinity = solver.infinity()

    # 2. Create the integer variables (x and y)
    # Variables are constrained to be integers within their bounds
    x = solver.IntVar(0.0, infinity, 'x')
    y = solver.IntVar(0.0, infinity, 'y')

    variables = []
    c = []
    for i in range(0, len(a[0])):
        x = solver.IntVar(0, infinity, f'x{i}')
        variables.append(x)
        c.append(1)

    for i, coefficients in enumerate(A):
        rhs_value = b[i]
        
        # Calculate the dot product: sum(A[i][j] * vars_list[j] for j in range(len(vars_list)))
        # This is the "vector form" equivalent in OR-Tools' syntax
        linear_expr = sum(coeff * var for coeff, var in zip(coefficients, variables))
        
        # Add the constraint: linear_expr == rhs_value
        solver.Add(linear_expr == rhs_value)

    # --- Vector Form for Objective ---
    objective_expr = sum(coeff * var for coeff, var in zip(c, variables))
    solver.Minimize(objective_expr)

    # 5. Invoke the solver and display the solution
    status = solver.Solve()

    if status == pywraplp.Solver.OPTIMAL:
        # print('Solution:')
        # print(f'Objective value (minimized x + y) = {solver.Objective().Value()}')
        # print(f'x = {x.solution_value()}')
        # print(f'y = {y.solution_value()}')
        return solver.Objective().Value()
    elif status == pywraplp.Solver.INFEASIBLE:
        print('Problem is infeasible (no integer solution exists).')
    else:
        print('Solver failed to find an optimal solution.')

result = 0
i = 0
fail = 0
for l in lines.split('\n'):
    i = i + 1
    if l == '':
        continue
    
    buttons = [toint(e[1:-1]) for e in re.findall('\([^(]*\)', l)]
    jolts = toint(re.findall('{.*}', l)[0][1:-1])
    a = convert(buttons, len(jolts))

    result += solve_smallest_integer_system(a, jolts)
    # for i in range(0, len(buttons)):
    #     print(r[0][i])
    #     sum += r[0][i]
    # print()

print(result)
print(fail)


