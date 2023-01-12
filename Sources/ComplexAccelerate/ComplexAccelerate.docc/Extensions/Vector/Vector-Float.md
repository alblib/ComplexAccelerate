#  Vector<Float>
Parallel operation specialization when `Element` is `Float`.

## Overview

This specialization is basically redefinition of `Accelerate.vDSP` and `Accelerate.vForce`. 
This is introduced to implement the general parallel operation structure ``Vector`` with general type arguments given.

## Topics

### Vector Creation
- ``Vector/create(repeating:count:)-8y371``
- ``Vector/arithmeticProgression(initialValue:increment:count:)-unsi``
- ``Vector/arithmeticProgression(initialValue:to:count:)-fd4g``
- ``Vector/geometricProgression(initialValue:ratio:count:)-1nkjs``
- ``Vector/geometricProgression(initialValue:to:count:)-3dkr0``

### Absolute and Negation Functions
- ``Vector/absolute(_:)-1apjz``
- ``Vector/negative(_:)-1oeus``
- ``Vector/negativeAbsolute(_:)-7udtk``

### Vector-Vector Parallel Arithmetics
- ``Vector/add(_:_:)-60afc``
- ``Vector/subtract(_:_:)-3br1h``
- ``Vector/multiply(_:_:)-7ixhb``
- ``Vector/divide(_:_:)-6p7p2``

### Vector-Scalar Parallel Arithmetics
- ``Vector/add(_:_:)-7ke2k``
- ``Vector/add(_:_:)-67o5g``
- ``Vector/subtract(_:_:)-9lyln``
- ``Vector/subtract(_:_:)-3sjzy``
- ``Vector/multiply(_:_:)-68i5u``
- ``Vector/multiply(_:_:)-6hqpp``
- ``Vector/divide(_:_:)-2o044``
- ``Vector/divide(_:_:)-2et72``

### Vector Reduction
- ``Vector/dot(_:_:)-6hz5k``
- ``Vector/sum(_:)-31jos``
- ``Vector/sumOfSquares(_:)-65plb``
- ``Vector/sumOfMagnitudes(_:)-85qjc``
- ``Vector/mean(_:)-1sr4r``
- ``Vector/meanSquare(_:)-90xjl``
- ``Vector/meanMagnitude(_:)-6fbdj``
- ``Vector/rootMeanSquare(_:)-6cmvm``

### Logarithms and Powers
- ``Vector/log(_:)-5lrpg``
- ``Vector/log2(_:)-6gneh``
- ``Vector/log10(_:)-850ne``
- ``Vector/exp(_:)-4q1l3``
- ``Vector/exp2(_:)-2g4wa``
- ``Vector/exp10(_:)-5jgnd``
- ``Vector/pow(bases:exponents:)-6zele``
- ``Vector/pow(bases:exponent:)-1abu5``
- ``Vector/pow(base:exponents:)-5fxrk``

### Trigonometric Functions
- ``Vector/sin(_:)-26pqg``
- ``Vector/cos(_:)-1a228``
- ``Vector/tan(_:)-4pfop``
- ``Vector/cot(_:)-8okp6``
- ``Vector/asin(_:)-3pg1g``
- ``Vector/acos(_:)-5znea``
- ``Vector/atan(_:)-1no2p``
- ``Vector/acoth(_:)-6ah6f``

### Hyperbolic Functions
- ``Vector/cosh(_:)-616jj``
- ``Vector/sinh(_:)-2gam1``
- ``Vector/tanh(_:)-8gqt4``
- ``Vector/coth(_:)-8naqh``
- ``Vector/asinh(_:)-9h9qo``
- ``Vector/acosh(_:)-2xbzi``
- ``Vector/atanh(_:)-2qsn``
- ``Vector/acoth(_:)-6ah6f``
