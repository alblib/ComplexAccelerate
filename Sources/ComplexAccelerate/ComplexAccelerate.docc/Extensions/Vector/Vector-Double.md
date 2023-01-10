#  Vector<Double>
Parallel operation specialization when `Element` is `Double`.

## Overview

This specialization is basically redefinition of `Accelerate.vDSP` and `Accelerate.vForce`. 
This is introduced to implement the general parallel operation structure ``Vector`` with general type arguments given.

## Topics

### Absolute and Negation Functions
- ``Vector/absolute(_:)-7o0es``
- ``Vector/negative(_:)-2s99a``
- ``Vector/negativeAbsolute(_:)-80l0l``

### Parallel Arithmetics
- ``Vector/add(_:_:)-22qwe``
- ``Vector/subtract(_:_:)-5ja40``
- ``Vector/multiply(_:_:)-80cf5``
- ``Vector/divide(_:_:)-72qmg``

### Arithmetics between a Vector and a Scalar
- ``Vector/add(_:scalar:)-3xqty``
- ``Vector/add(scalar:_:)-4kkdd``
- ``Vector/subtract(_:scalar:)-15m7l``
- ``Vector/subtract(scalar:_:)-6i2az``
- ``Vector/multiply(_:scalar:)-833zl``
- ``Vector/multiply(scalar:_:)-2zz37``
- ``Vector/divide(_:scalar:)-6iqmp``
- ``Vector/divide(scalar:_:)-17qxa``

### Vector Reduction
- ``Vector/sum(_:)-5rtwa``
- ``Vector/sumOfSquares(_:)-1fy6i``
- ``Vector/sumOfMagnitudes(_:)-91nco``
- ``Vector/mean(_:)-9spj9``
- ``Vector/meanSquare(_:)-4ga46``
- ``Vector/meanMagnitude(_:)-1bhxx``
- ``Vector/rootMeanSquare(_:)-jmm2``
- ``Vector/dot(_:_:)-2gfxy``

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
- ``Vector/asin(_:)-6nxx3``
- ``Vector/acos(_:)-3effs``
- ``Vector/atan(_:)-9rahr``
