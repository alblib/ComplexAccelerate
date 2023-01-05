#  Hyperbolic and Trigonometric Functions
Connections between hyperbolic functions and trigonometric functions on complex domain.

## Overview

Considering the 
Euler's formula
![exp(iz) = cos(z) + i * sin(z),](euler-formula)
definitions of trigonometric functions is written in exponential functions,
which then immediately can be inferred to be related to 
hyperbolic functions:
![cos(z) = (exp(iz) + exp(-iz)) / 2 <-> cosh(z) = (exp(z) + exp(-z)) / 2](cos-cosh-equiv)
![sin(z) = (exp(iz) - exp(-iz)) / (2 * i) <-> sinh(z) = (exp(z) - exp(-z)) / 2](sin-sinh-equiv)
Thus, in the complex domain, trigonometric functions are defined using hyperbolic functions.
![cos(z) = cosh(i * z)](cos-cosh-def)
![sin(z) = -i * sinh(i * z)](sin-sinh-def)


On the other hand, exponential functions and their combinations, hyperbolic and trigonometric functions, are surjections, and thus their inverse functions are logarithmic and multi-branched.
To see some explanation on logarithms of complex numbers and its multi-branch features, see ``log(_:)-52em1`` or ``log(_:)-3ushm``.
Arc sines, arc cosines, and other conventions for inverse functions pick certain branch only to make one-to-one.
*cos⁻¹* and *cosh⁻¹* may be chosen different branch to be a one-to-one function on the first quadrant on real domain, but the both still can be inverses of *cosh*.
Henceforward, we discuss those sophiscated equivalences of inverse functions.


## Discussion

### Cosine Function

![w = cosh(z) = (exp(z) + exp(-z)) / 2](cosh-def)

![exp(2z) - 2w exp(z) + 1 = 0](acosh-solve-eq)

![exp(z) = w +- sqrt(w^2 - 1)](acosh-exp)

### Sine Function
![w = sinh(z) = (exp(z) - exp(-z)) / 2](sinh-def)

![exp(2z) - 2w exp(z) - 1 = 0](asinh-solve-eq)

![exp(z) = w +- sqrt(w^2 + 1)](asinh-exp)


### Tangent and Cotangent
