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
