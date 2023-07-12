# Online Python - IDE, Editor, Compiler, Interpreter
import math

kelvin = 273.15

surD = -9.57
lakeT = 2.0
surT = - 6.16
time = 3
TAW = 0.0
TDW = 0.0

if(lakeT-surD<10.5):
    TAW =-0.26 + 0.79*surT + 0.24*lakeT
    TDW = -0.43 + 0.68*surD +0.07*lakeT
else:
    TAW = -0.63 + 0.75*surT + 0.11*lakeT
    TDW = -3.86 + 0.64*surD + 0.24*lakeT

print(TAW)
print(TDW)
