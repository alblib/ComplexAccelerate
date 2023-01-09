#  Vector<Complex<Float>>
Parallel operation specialization on complex numbers when `Element` is ``Complex`` `<Float>`.

## Overview

This specialization provides convenient Swift-styled parallel computations on complex numbers,
which is defined in `Accelerate.vDSP_z...`. 
As parallel mathematical functions on complex array is not defined by system,
we defined such functions using `vForce` functions.


## Topics

### Absolute and Negation Functions
- ``Vector/absolute(_:)-1xm7m``
- ``Vector/negative(_:)-2yqio``

### Parallel Arithmetics Between Complexes
- ``Vector/add(_:_:)-7ht90``
- ``Vector/subtract(_:_:)-fd0u``
- ``Vector/multiply(_:_:)-3lubu``
- ``Vector/multiply(conjugate:_:)``
- ``Vector/divide(_:_:)-8dqqs``

### Parallel Arithmetics Between Reals and Complexes

- ``Vector/add(_:_:)-4jlff``
- ``Vector/add(_:_:)-8yn9h``
- ``Vector/subtract(_:_:)-4d6ym``
- ``Vector/multiply(_:_:)-7qu33``
- ``Vector/multiply(_:_:)-9zkpc``
- ``Vector/divide(_:_:)-52plx``
