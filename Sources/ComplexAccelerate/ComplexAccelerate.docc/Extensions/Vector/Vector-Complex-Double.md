#  Vector<Complex<Double>>
Parallel operation specialization on complex numbers when `Element` is ``Complex``​`<Double>`.

## Overview

This specialization provides convenient Swift-styled parallel computations on complex numbers,
which is defined in `Accelerate.vDSP_z...`. 
As parallel mathematical functions on complex array is not defined by system,
we defined such functions using `vForce` functions.


## Topics

### Vector Creation
- ``Vector/create(reals:imaginaries:)-2t51g``
- ``Vector/create(repeating:count:)-5jl1j``
- ``Vector/arithmeticProgression(initialValue:increment:count:)-9bp8v``
- ``Vector/arithmeticProgression(initialValue:to:count:)-74t2v``
- ``Vector/geometricProgression(initialValue:ratio:count:)-su24``
- ``Vector/geometricProgression(initialValue:to:count:)-8xd97``

### Components and Absolute Values

- ``Vector/negative(_:)-2yqio``
- ``Vector/conjugate(_:)-7kdlg``

- ``Vector/absolute(_:)-1xm7m``
- ``Vector/phase(_:)-3j4n4``

- ``Vector/realsAndImaginaries(_:)-1ykv1``
- ``Vector/reals(_:)-5fonh``
- ``Vector/imaginaries(_:)-1mrf``


### Vector-Vector Parallel Arithmetics
- ``Vector/add(_:_:)-9l42e``
- ``Vector/add(_:_:)-2ogxq``
- ``Vector/add(_:_:)-87s0o``
- ``Vector/subtract(_:_:)-2076f``
- ``Vector/subtract(_:_:)-5qaq``
- ``Vector/subtract(_:_:)-dbnh``
- ``Vector/multiply(_:_:)-99hs2``
- ``Vector/multiply(_:_:)-3iomx``
- ``Vector/multiply(_:_:)-85bmt``
- ``Vector/multiply(conjugate:_:)-8f2z9``
- ``Vector/multiply(conjugate:_:)-4r6vf``
- ``Vector/multiply(_:conjugate:)-60uq6``
- ``Vector/divide(_:_:)-5eko8``
- ``Vector/divide(_:_:)-3zueb``
- ``Vector/divide(_:_:)-2o74s``


### Vector-Scalar Parallel Arithmetics
- ``Vector/add(_:_:)-8l7dy``
- ``Vector/add(_:_:)-9nbah``
- ``Vector/add(_:_:)-5ceto``
- ``Vector/add(_:_:)-7l4nj``
- ``Vector/subtract(_:_:)-6y9o3``
- ``Vector/subtract(_:_:)-7mvra``
- ``Vector/subtract(_:_:)-9y53u``
- ``Vector/subtract(_:_:)-8uqnz``
- ``Vector/multiply(_:_:)-qqzt``
- ``Vector/multiply(_:_:)-8yg6c``
- ``Vector/multiply(_:_:)-2axe3``
- ``Vector/multiply(_:_:)-1bgug``
- ``Vector/multiply(conjugate:_:)-6e6px``
- ``Vector/multiply(_:conjugate:)-1sa8e``
- ``Vector/divide(_:_:)-8062u``
- ``Vector/divide(_:_:)-hcx1``
- ``Vector/divide(_:_:)-926ye``
- ``Vector/divide(_:_:)-5ka69``

### Logarithms and Powers
- ``Vector/log(_:)-6f7v``
- ``Vector/exp(_:)-pjx7``
- ``Vector/expi(_:)-200k8``
- ``Vector/expi(_:)-2isfb``
- ``Vector/pow(bases:exponents:)-36xxf``
- ``Vector/pow(bases:exponents:)-1ea9q``
- ``Vector/pow(bases:exponents:)-9rqkz``
- ``Vector/pow(bases:exponent:)-6k6pl``
- ``Vector/pow(bases:exponent:)-7dxnt``
- ``Vector/pow(bases:exponent:)-91veh``
- ``Vector/pow(base:exponents:)-gu3h``
- ``Vector/pow(base:exponents:)-8kxqs``
- ``Vector/pow(base:exponents:)-36fi2``

### Hyperbolic Functions
- ``Vector/cosh(_:)-752i1``
- ``Vector/sinh(_:)-3dzsb``
- ``Vector/tanh(_:)-rwgv``
- ``Vector/coth(_:)-xvsw``
- ``Vector/acosh(_:)-94byf``
- ``Vector/asinh(_:)-9ui3u``
- ``Vector/atanh(_:)-7vctq``
- ``Vector/acoth(_:)-1n1rn``

### Trigonometric Functions
- ``Vector/sin(_:)-3rq9``
- ``Vector/cos(_:)-9w5as``
- ``Vector/tan(_:)-3zvvy``
- ``Vector/cot(_:)-6z74y``
- ``Vector/asin(_:)-2fxyq``
- ``Vector/acos(_:)-h60w``
- ``Vector/atan(_:)-6j684``
- ``Vector/acot(_:)-8vsfc``
