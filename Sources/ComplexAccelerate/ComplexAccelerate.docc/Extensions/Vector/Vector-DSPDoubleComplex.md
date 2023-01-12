#  Vector<DSPDoubleComplex>
Parallel operation specialization on complex numbers when `Element` is `DSPDoubleComplex`.

## Overview

This specialization provides convenient Swift-styled parallel computations on complex numbers,
which is defined in `Accelerate.vDSP_z...`. 
As parallel mathematical functions on complex array is not defined by system,
we defined such functions using `vForce` functions.


## Topics

### Vector Creation
- ``Vector/castToComplexes(_:)-1vtim``
- ``Vector/create(reals:imaginaries:)-8zz6p``
- ``Vector/create(repeating:count:)-21jot``
- ``Vector/arithmeticProgression(initialValue:increment:count:)-9jshe``
- ``Vector/arithmeticProgression(initialValue:to:count:)-99vd2``
- ``Vector/geometricProgression(initialValue:ratio:count:)-7ry1h``
- ``Vector/geometricProgression(initialValue:to:count:)-997e1``

### Components and Absolute Values

- ``Vector/negative(_:)-6gdq7``
- ``Vector/conjugate(_:)-ky0t``

- ``Vector/absolute(_:)-598pm``
- ``Vector/phase(_:)-6ciyd``

- ``Vector/realsAndImaginaries(_:)-18c58``
- ``Vector/reals(_:)-870xo``
- ``Vector/imaginaries(_:)-7e3i``


### Vector-Vector Parallel Arithmetics
- ``Vector/add(_:_:)-890js``
- ``Vector/add(_:_:)-194v5``
- ``Vector/add(_:_:)-kiyd``
- ``Vector/subtract(_:_:)-8l3a2``
- ``Vector/subtract(_:_:)-88gux``
- ``Vector/subtract(_:_:)-s72p``
- ``Vector/multiply(_:_:)-13p3k``
- ``Vector/multiply(_:_:)-33e4n``
- ``Vector/multiply(_:_:)-27lkp``
- ``Vector/multiply(conjugate:_:)-4trah``
- ``Vector/multiply(conjugate:_:)-43svn``
- ``Vector/multiply(_:conjugate:)-5jaka``
- ``Vector/multiply(_:conjugate:)-1vxqw``
- ``Vector/divide(_:_:)-516zg``
- ``Vector/divide(_:_:)-9w2st``
- ``Vector/divide(_:_:)-1oqa4``


### Vector-Scalar Parallel Arithmetics
- ``Vector/add(_:_:)-73aip``
- ``Vector/add(_:_:)-4rj64``
- ``Vector/add(_:_:)-17kgo``
- ``Vector/add(_:_:)-3t6qk``
- ``Vector/subtract(_:_:)-2d1fo``
- ``Vector/subtract(_:_:)-43pis``
- ``Vector/subtract(_:_:)-1scku``
- ``Vector/subtract(_:_:)-9sgcr``
- ``Vector/multiply(_:_:)-b80d``
- ``Vector/multiply(_:_:)-83ujx``
- ``Vector/multiply(_:_:)-6kpmf``
- ``Vector/multiply(_:_:)-6hc3v``
- ``Vector/multiply(conjugate:_:)-8nbxl``
- ``Vector/multiply(_:conjugate:)-80edj``
- ``Vector/divide(_:_:)-5p1kq``
- ``Vector/divide(_:_:)-54dr4``
- ``Vector/divide(_:_:)-20htt``
- ``Vector/divide(_:_:)-4tzs2``

### Vector Reduction
- ``Vector/dot(_:_:)-7wxun``
- ``Vector/dot(_:_:)-wkc6``
- ``Vector/dot(_:_:)-5p19i``
- ``Vector/dot(conjugate:_:)-37ivi``
- ``Vector/dot(_:conjugate:)-8pcln``

### Logarithms and Powers
- ``Vector/log(_:)-23025``
- ``Vector/exp(_:)-5wd4``
- ``Vector/expi(_:)-7adfa``
- ``Vector/expi(_:)-3lb1y``
- ``Vector/sqrt(_:)-8zxt6``
- ``Vector/pow(bases:exponents:)-1b01z``
- ``Vector/pow(bases:exponents:)-6t178``
- ``Vector/pow(bases:exponents:)-3zsea``
- ``Vector/pow(bases:exponent:)-4ezwc``
- ``Vector/pow(bases:exponent:)-26lgp``
- ``Vector/pow(bases:exponent:)-6fdf8``
- ``Vector/pow(base:exponents:)-9ih5p``
- ``Vector/pow(base:exponents:)-4vs5c``
- ``Vector/pow(base:exponents:)-7q7kv``

### Hyperbolic Functions
- ``Vector/cosh(_:)-tss9``
- ``Vector/sinh(_:)-4yck7``
- ``Vector/tanh(_:)-1ea8k``
- ``Vector/coth(_:)-393ib``
- ``Vector/acosh(_:)-42fts``
- ``Vector/asinh(_:)-26yjz``
- ``Vector/atanh(_:)-9dbk0``
- ``Vector/acoth(_:)-3a00e``

### Trigonometric Functions
- ``Vector/sin(_:)-8643j``
- ``Vector/cos(_:)-4qu3s``
- ``Vector/tan(_:)-894q0``
- ``Vector/cot(_:)-1vg6e``
- ``Vector/asin(_:)-4mi1z``
- ``Vector/acos(_:)-axjj``
- ``Vector/atan(_:)-79pcf``
- ``Vector/acot(_:)-9gor8``
