#  Vector<Complex<Float>>
Parallel operation specialization on complex numbers when `Element` is ``Complex``​`<Float>`.

## Overview

This specialization of ``Vector`` on ``Complex``​`<Float>` provides convenient Swift-styled wrapping of
parallel computations or their combinations on complex numbers,
which is defined in `Accelerate.vDSP_z...` and `vForce....` . 


## Topics

### Vector Creation
- ``Vector/castToComplexes(_:)-jauq``
- ``Vector/create(reals:imaginaries:)-95d6a``
- ``Vector/create(repeating:count:)-665o``
- ``Vector/arithmeticProgression(initialValue:increment:count:)-9ixy0``
- ``Vector/arithmeticProgression(initialValue:to:count:)-1s8ym``
- ``Vector/geometricProgression(initialValue:ratio:count:)-8y1vf``
- ``Vector/geometricProgression(initialValue:to:count:)-oqaa``

### Components and Absolute Values

- ``Vector/negative(_:)-2yqio``
- ``Vector/conjugate(_:)-1skfl``

- ``Vector/absolute(_:)-1xm7m``
- ``Vector/phase(_:)-8m9a9``
- ``Vector/squareMagnitudes(_:)-25eyi``

- ``Vector/realsAndImaginaries(_:)-9j4nn``
- ``Vector/reals(_:)-23bx1``
- ``Vector/imaginaries(_:)-wtv4``


### Vector-Vector Parallel Arithmetics
- ``Vector/add(_:_:)-7ht90``
- ``Vector/add(_:_:)-4jlff``
- ``Vector/add(_:_:)-8yn9h``
- ``Vector/subtract(_:_:)-fd0u``
- ``Vector/subtract(_:_:)-4d6ym``
- ``Vector/subtract(_:_:)-2jlsm``
- ``Vector/multiply(_:_:)-3lubu``
- ``Vector/multiply(_:_:)-9zkpc``
- ``Vector/multiply(_:_:)-7qu33``
- ``Vector/multiply(conjugate:_:)-7z2qu``
- ``Vector/multiply(conjugate:_:)-8og92``
- ``Vector/multiply(_:conjugate:)-52b6m``
- ``Vector/multiply(_:conjugate:)-53ufj``
- ``Vector/divide(_:_:)-8dqqs``
- ``Vector/divide(_:_:)-52plx``
- ``Vector/divide(_:_:)-639ll``


### Vector-Scalar Parallel Arithmetics
- ``Vector/add(_:_:)-534zi``
- ``Vector/add(_:_:)-5n8gm``
- ``Vector/add(_:_:)-859n5``
- ``Vector/add(_:_:)-5rjcx``
- ``Vector/subtract(_:_:)-4p2vq``
- ``Vector/subtract(_:_:)-2kdnb``
- ``Vector/subtract(_:_:)-9l8jo``
- ``Vector/subtract(_:_:)-1dad0``
- ``Vector/multiply(_:_:)-6v9pd``
- ``Vector/multiply(_:_:)-6k5we``
- ``Vector/multiply(_:_:)-4n06c``
- ``Vector/multiply(_:_:)-2du5r``
- ``Vector/multiply(conjugate:_:)-3z389``
- ``Vector/multiply(_:conjugate:)-6kn0``
- ``Vector/divide(_:_:)-9895a``
- ``Vector/divide(_:_:)-9abi1``
- ``Vector/divide(_:_:)-258xz``
- ``Vector/divide(_:_:)-4id56``

### Dot Product
- ``Vector/dot(_:_:)-5m5qu``
- ``Vector/dot(_:_:)-55p6z``
- ``Vector/dot(_:_:)-82krw``
- ``Vector/dot(conjugate:_:)-9o9mm``
- ``Vector/dot(_:conjugate:)-7a2zf``

### Logarithms and Powers
- ``Vector/log(_:)-66zek``
- ``Vector/exp(_:)-8txxv``
- ``Vector/expi(_:)-wkfx``
- ``Vector/expi(_:)-5rbto``
- ``Vector/sqrt(_:)-2w8wd``
- ``Vector/pow(bases:exponents:)-14uxs``
- ``Vector/pow(bases:exponents:)-50wal``
- ``Vector/pow(bases:exponents:)-53e0e``
- ``Vector/pow(bases:exponent:)-1g6y0``
- ``Vector/pow(bases:exponent:)-5cuyw``
- ``Vector/pow(bases:exponent:)-6c7y2``
- ``Vector/pow(base:exponents:)-7fxlj``
- ``Vector/pow(base:exponents:)-46s4x``
- ``Vector/pow(base:exponents:)-70q1n``

### Hyperbolic Functions
- ``Vector/cosh(_:)-49du4``
- ``Vector/sinh(_:)-9rzb``
- ``Vector/tanh(_:)-4topg``
- ``Vector/coth(_:)-7u71k``
- ``Vector/acosh(_:)-3p1vc``
- ``Vector/asinh(_:)-187h3``
- ``Vector/atanh(_:)-4cok5``
- ``Vector/acoth(_:)-54lbv``

### Trigonometric Functions
- ``Vector/sin(_:)-5cgbp``
- ``Vector/cos(_:)-3g98j``
- ``Vector/tan(_:)-555fd``
- ``Vector/cot(_:)-9r5w3``
- ``Vector/asin(_:)-6hn8y``
- ``Vector/acos(_:)-25y9q``
- ``Vector/atan(_:)-7ldq9``
- ``Vector/acot(_:)-9kovz``

### Vector Reduction
- ``Vector/sum(_:)-47jai``
- ``Vector/sumOfSquareMagnitudes(_:)-45qbx``
- ``Vector/mean(_:)-27czp``
- ``Vector/meanSquareMagnitudes(_:)-135rc``
- ``Vector/rootMeanSquareMagnitude(_:)-40g92``
