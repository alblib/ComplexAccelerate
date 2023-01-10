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

### Parallel Arithmetics Between Complex Vectors
- ``Vector/add(_:_:)-7ht90``
- ``Vector/subtract(_:_:)-fd0u``
- ``Vector/multiply(_:_:)-3lubu``
- ``Vector/multiply(conjugate:_:)-7z2qu``
- ``Vector/divide(_:_:)-8dqqs``

### Parallel Arithmetics between a Real Vector and a Complex Vector

- ``Vector/add(_:_:)-4jlff``
- ``Vector/add(_:_:)-8yn9h``
- ``Vector/subtract(_:_:)-4d6ym``
- ``Vector/multiply(_:_:)-7qu33``
- ``Vector/multiply(_:_:)-9zkpc``
- ``Vector/divide(_:_:)-52plx``


### Arithmetics between a Vector and a Scalar
- ``Vector/add(_:_:)-534zi``
- ``Vector/add(_:_:)-859n5``
- ``Vector/subtract(_:_:)-4p2vq``
- ``Vector/subtract(_:_:)-9l8jo``
- ``Vector/multiply(_:_:)-6v9pd``
- ``Vector/multiply(conjugate:_:)-3z389``
- ``Vector/multiply(_:_:)-6k5we``
- ``Vector/multiply(_:_:)-2du5r``
