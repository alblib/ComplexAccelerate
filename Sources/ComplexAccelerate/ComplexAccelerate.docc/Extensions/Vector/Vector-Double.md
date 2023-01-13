#  Vector<Double>
Parallel operation specialization when `Element` is `Double`.

## Overview

This specialization is basically redefinition of `Accelerate.vDSP` and `Accelerate.vForce`. 
This is introduced to implement the general parallel operation structure ``Vector`` with general type arguments given.

## Topics

### Vector Creation
- ``Vector/create(repeating:count:)-5yog6``
- ``Vector/arithmeticProgression(initialValue:increment:count:)-8kcr``
- ``Vector/arithmeticProgression(initialValue:to:count:)-5ipam``
- ``Vector/geometricProgression(initialValue:ratio:count:)-1ohnx``
- ``Vector/geometricProgression(initialValue:to:count:)-4w0ld``

### Absolute and Negation Functions
- ``Vector/absolute(_:)-7o0es``
- ``Vector/square(_:)-5q4pa``
- ``Vector/negative(_:)-2s99a``
- ``Vector/negativeAbsolute(_:)-80l0l``

### Vector-Vector Parallel Arithmetics
- ``Vector/add(_:_:)-22qwe``
- ``Vector/subtract(_:_:)-5ja40``
- ``Vector/multiply(_:_:)-80cf5``
- ``Vector/divide(_:_:)-72qmg``

### Vector-Scalar Parallel Arithmetics
- ``Vector/add(_:_:)-3osaa``
- ``Vector/add(_:_:)-md9z``
- ``Vector/subtract(_:_:)-3ypj3``
- ``Vector/subtract(_:_:)-6k21o``
- ``Vector/multiply(_:_:)-1fo9x``
- ``Vector/multiply(_:_:)-15tzy``
- ``Vector/divide(_:_:)-2cr22``
- ``Vector/divide(_:_:)-2cn7o``

### Vector Reduction
- ``Vector/dot(_:_:)-2gfxy``
- ``Vector/sum(_:)-5rtwa``
- ``Vector/sumOfSquares(_:)-1fy6i``
- ``Vector/sumOfMagnitudes(_:)-91nco``
- ``Vector/mean(_:)-9spj9``
- ``Vector/meanSquare(_:)-4ga46``
- ``Vector/meanMagnitude(_:)-1bhxx``
- ``Vector/rootMeanSquare(_:)-jmm2``

### Logarithms and Powers
- ``Vector/log(_:)-7vr9r``
- ``Vector/log2(_:)-48hjh``
- ``Vector/log10(_:)-11kg1``
- ``Vector/exp(_:)-1u613``
- ``Vector/exp2(_:)-66x3o``
- ``Vector/exp10(_:)-6whyq``
- ``Vector/pow(bases:exponents:)-5qf04``
- ``Vector/pow(bases:exponent:)-1x9rt``
- ``Vector/pow(base:exponents:)-8ydvl``

### Trigonometric Functions
- ``Vector/sin(_:)-3dykw``
- ``Vector/cos(_:)-5msx``
- ``Vector/tan(_:)-13ve``
- ``Vector/cot(_:)-1alba``
- ``Vector/asin(_:)-6nxx3``
- ``Vector/acos(_:)-3effs``
- ``Vector/atan(_:)-9rahr``
- ``Vector/acot(_:)-qh5k``

### Hyperbolic Functions
- ``Vector/cosh(_:)-6i0es``
- ``Vector/sinh(_:)-7qba1``
- ``Vector/tanh(_:)-7q16h``
- ``Vector/coth(_:)-6u9rk``
- ``Vector/asinh(_:)-4r9aw``
- ``Vector/acosh(_:)-86lqi``
- ``Vector/atanh(_:)-9iqqv``
- ``Vector/acoth(_:)-2s987``
