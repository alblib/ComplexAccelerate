#  Vector<DSPComplex>
Parallel operation specialization on complex numbers when `Element` is `DSPComplex`.

## Overview

This specialization provides convenient Swift-styled parallel computations on complex numbers,
which is defined in `Accelerate.vDSP_z...`. 
As parallel mathematical functions on complex array is not defined by system,
we defined such functions using `vForce` functions.


## Topics

### Vector Creation
- ``Vector/castToComplexes(_:)-640u``
- ``Vector/create(reals:imaginaries:)-6uvx``
- ``Vector/create(repeating:count:)-7ztd0``
- ``Vector/arithmeticProgression(initialValue:increment:count:)-3oqzu``
- ``Vector/arithmeticProgression(initialValue:to:count:)-1wo9v``
- ``Vector/geometricProgression(initialValue:ratio:count:)-6gnba``
- ``Vector/geometricProgression(initialValue:to:count:)-9u481``

### Components and Absolute Values

- ``Vector/negative(_:)-6f1xs``
- ``Vector/conjugate(_:)-5ow0p``

- ``Vector/absolute(_:)-92j68``
- ``Vector/phase(_:)-4d4kt``

- ``Vector/realsAndImaginaries(_:)-2ykyz``
- ``Vector/reals(_:)-5iv5w``
- ``Vector/imaginaries(_:)-59h3k``


### Vector-Vector Parallel Arithmetics
- ``Vector/add(_:_:)-19o6e``
- ``Vector/add(_:_:)-10bb7``
- ``Vector/add(_:_:)-790y``
- ``Vector/subtract(_:_:)-37uwo``
- ``Vector/subtract(_:_:)-96am5``
- ``Vector/subtract(_:_:)-uo9e``
- ``Vector/multiply(_:_:)-33p2y``
- ``Vector/multiply(_:_:)-5eup2``
- ``Vector/multiply(_:_:)-50ojh``
- ``Vector/multiply(conjugate:_:)-4jjyw``
- ``Vector/multiply(conjugate:_:)-5s71x``
- ``Vector/multiply(_:conjugate:)-5o2q``
- ``Vector/multiply(_:conjugate:)-cmp1``
- ``Vector/divide(_:_:)-80t21``
- ``Vector/divide(_:_:)-572kp``
- ``Vector/divide(_:_:)-j18i``


### Vector-Scalar Parallel Arithmetics
- ``Vector/add(_:_:)-1oesg``
- ``Vector/add(_:_:)-5ntwt``
- ``Vector/add(_:_:)-6ka9``
- ``Vector/add(_:_:)-89d5l``
- ``Vector/subtract(_:_:)-64fqs``
- ``Vector/subtract(_:_:)-7byza``
- ``Vector/subtract(_:_:)-2jdf3``
- ``Vector/subtract(_:_:)-34gsg``
- ``Vector/multiply(_:_:)-8jb6z``
- ``Vector/multiply(_:_:)-3w8sp``
- ``Vector/multiply(_:_:)-8bemx``
- ``Vector/multiply(_:_:)-4amn4``
- ``Vector/multiply(conjugate:_:)-2582g``
- ``Vector/multiply(_:conjugate:)-7pgmu``
- ``Vector/divide(_:_:)-9a3gx``
- ``Vector/divide(_:_:)-1hwl``
- ``Vector/divide(_:_:)-96rge``
- ``Vector/divide(_:_:)-3sapc``

### Vector Reduction
- ``Vector/dot(_:_:)-1bouq``
- ``Vector/dot(_:_:)-2un8g``
- ``Vector/dot(_:_:)-5ymou``
- ``Vector/dot(conjugate:_:)-49bs1``
- ``Vector/dot(_:conjugate:)-59pnu``

### Logarithms and Powers
- ``Vector/log(_:)-679lf``
- ``Vector/exp(_:)-1xcll``
- ``Vector/expi(_:)-1vb2j``
- ``Vector/expi(_:)-425u8``
- ``Vector/sqrt(_:)-7i54t``
- ``Vector/pow(bases:exponents:)-14rw9``
- ``Vector/pow(bases:exponents:)-2ky9y``
- ``Vector/pow(bases:exponents:)-2repz``
- ``Vector/pow(bases:exponent:)-7mwry``
- ``Vector/pow(bases:exponent:)-3kaue``
- ``Vector/pow(bases:exponent:)-8wti2``
- ``Vector/pow(base:exponents:)-6ws30``
- ``Vector/pow(base:exponents:)-1nkac``
- ``Vector/pow(base:exponents:)-3v1ti``

### Hyperbolic Functions
- ``Vector/cosh(_:)-9x7t6``
- ``Vector/sinh(_:)-44082``
- ``Vector/tanh(_:)-8xm94``
- ``Vector/coth(_:)-35zxr``
- ``Vector/acosh(_:)-9w9il``
- ``Vector/asinh(_:)-9pduo``
- ``Vector/atanh(_:)-8xzfv``
- ``Vector/acoth(_:)-3ufrm``

### Trigonometric Functions
- ``Vector/sin(_:)-1ov1h``
- ``Vector/cos(_:)-59smh``
- ``Vector/tan(_:)-8u706``
- ``Vector/cot(_:)-98gt8``
- ``Vector/asin(_:)-9ooex``
- ``Vector/acos(_:)-1hd1q``
- ``Vector/atan(_:)-9r7or``
- ``Vector/acot(_:)-3u70s``
