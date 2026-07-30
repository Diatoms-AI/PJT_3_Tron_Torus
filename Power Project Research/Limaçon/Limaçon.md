The shape you have created is mathematically known as an **$(11, 11)$ Torus Link**.

In Knot Theory, a torus link $T(p, q)$ where $p$ and $q$ share a common divisor consists of multiple interlinked components. Since you have 11 loops that each wrap once around the center and once around the tube, you have created a system of **11 parallel $(1,1)$ Torus Knots**.

Here is the mathematical formulation for the entire set.

### 1. The Parametric Formula

To describe all 11 loops, we use a discrete parameter $k$ (an integer from 0 to 10) to select the loop, and a continuous parameter $t$ (from $0$ to $2\pi$) to draw the curve.

For the $k$-th loop:

$$\begin{align*} x_k(t) &= (R + r \cos t) \cos\left(t + \frac{2\pi k}{11}\right) \\ y_k(t) &= (R + r \cos t) \sin\left(t + \frac{2\pi k}{11}\right) \\ z_k(t) &= r \sin t \end{align*}$$

### 2. The Variables defined

Based on your OpenSCAD code, the constants are derived from your original limaçon dimensions:

- **$R$ (Major Radius):** 50
    
    - _Derived from $(a+b + |a-b|)/2$_
        
- **$r$ (Minor Radius):** 30
    
    - _Derived from $(a+b - |a-b|)/2$_
        
- **$k$ (Loop Index):** An integer in the set $\{0, 1, 2, ..., 10\}$.
    
- **$t$ (Parameter):** The angle varying from $0$ to $2\pi$ (0° to 360°).
    

### 3. Why this creates a "Nest" of Limaçons

If you look at this shape from the top down (projecting it onto the 2D plane by ignoring $z$), the equation simplifies to the polar form:

$$\text{Radius}(\theta) = R + r \cos(\theta - \text{phase shift})$$

This proves that **every single one of the 11 loops is a perfect Limaçon** in its 2D shadow, merely rotated by $32.7^\circ$ ($\frac{360}{11}$) from its neighbor. In 3D space, they spiral around the same torus surface without ever touching, creating a "fiber bundle" or cage effect.