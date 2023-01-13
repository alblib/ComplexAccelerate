#  Vector<Int32>
Parallel operation specialization when `Element` is `Int32`.

## Overview

This specialization is basically redefinition of `Accelerate.vDSP` and `Accelerate.vForce`. 
This is introduced to implement the general parallel operation structure ``Vector`` with general type arguments given.

For those functions which does not have parallel implementation by `vecLib` in `Accelerate.vDSP`,
the default `for`-loop implementation in ``Vector`` is used.
Thus, you can use ``Vector/arithmeticProgression(initialValue:increment:count:)-7krbs``
in `Vector<Int32>`, but the generic implementation is referenced,
so the vector is created by `for`-loop.

## Topics

### Vector Creation
- ``Vector/create(repeating:count:)-3too8``

### Absolute and Negation Functions

- ``Vector/absolute(_:)-es6h``

### Parallel Arithmetics

- ``Vector/add(_:_:)-28hjr``
- ``Vector/add(_:_:)-80wbp``
- ``Vector/add(_:_:)-73ypk``
