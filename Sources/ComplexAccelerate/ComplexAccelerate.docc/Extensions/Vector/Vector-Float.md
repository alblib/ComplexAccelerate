#  Vector<Float>
Parallel operation specialization when `Element` is `Float`.

## Overview

This specialization is basically redefinition of `Accelerate.vDSP` and `Accelerate.vForce`. 
This is introduced to implement the general parallel operation structure ``Vector`` with general type arguments given.

## Topics

### Absolute and Negation Functions
- ``Vector/absolute(_:)-1apjz``
- ``Vector/negative(_:)-1oeus``
- ``Vector/negativeAbsolute(_:)-7udtk``

### Parallel Arithmetics
- ``Vector/add(_:_:)-60afc``
- ``Vector/subtract(_:_:)-3br1h``
- ``Vector/multiply(_:_:)-7ixhb``
- ``Vector/divide(_:_:)-6p7p2``

### Arithmetics between a Vector and a Scalar
- ``Vector/add(_:scalar:)-7vu9b``
- ``Vector/add(scalar:_:)-3wezv``
- ``Vector/subtract(_:scalar:)-19ce3``
- ``Vector/subtract(scalar:_:)-365qo``
- ``Vector/multiply(_:_:)-6k5we``
- ``Vector/multiply(scalar:_:)-66347``
- ``Vector/divide(_:scalar:)-6ygv5``
- ``Vector/divide(scalar:_:)-9gj4e``

### Vector Reduction
- ``Vector/sum(_:)-31jos``
- ``Vector/sumOfSquares(_:)-65plb``
- ``Vector/sumOfMagnitudes(_:)-85qjc``
- ``Vector/mean(_:)-1sr4r``
- ``Vector/meanSquare(_:)-90xjl``
- ``Vector/meanMagnitude(_:)-6fbdj``
- ``Vector/rootMeanSquare(_:)-6cmvm``
- ``Vector/dot(_:_:)-6hz5k``

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
- ``Vector/asin(_:)-3pg1g``
- ``Vector/acos(_:)-5znea``
- ``Vector/atan(_:)-1no2p``
