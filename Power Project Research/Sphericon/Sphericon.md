

The **sphericon** is a geometric solid that does not have a single, simple polynomial equation like a sphere ($x^2+y^2+z^2=r^2$). Instead, it is defined **piecewise** or by its construction from a bicone.

### 1. Mathematical Definition (Piecewise Formula)

The most precise mathematical definition describes the sphericon as two halves of a bicone joined at a 90-degree offset. If we define the sphericon with radius $a$ (where $a$ is the radius of the original bicone's base), the surface is defined by the following two conditions in Cartesian coordinates:

$$\text{For } x \le 0: \quad \sqrt{x^2 + y^2} + |z| = a$$

$$\text{For } x \ge 0: \quad \sqrt{x^2 + z^2} + |y| = a$$

**Explanation:**

- The region where $x \le 0$ represents half of a standard bicone (two cones joined at their bases).
    
- The region where $x \ge 0$ represents the other half of the bicone, but rotated 90 degrees so that its cross-section is perpendicular to the first half.
    

### 2. Geometric Formulas

Despite its complex appearance, the sphericon has surprisingly clean formulas for its physical properties, derived directly from the bicone.

- **Volume ($V$):**
    
    The volume of a sphericon is exactly half the volume of a sphere with the same radius.
    
    $$V = \frac{2}{3}\pi a^3$$
    
- **Surface Area ($S$):**
    
    The surface area is derived from the lateral surface area of the two cones that form it.
    
    $$S = 2\sqrt{2}\pi a^2$$
    

### 3. Key Properties

- **Single Continuous Surface:** Unlike a cylinder or a cube, the sphericon has only one continuous surface side (like a Möbius strip). If you trace a line along its surface, you will traverse both "sides" and return to your starting point without crossing an edge.
    
- **Two Edges:** It has two discontinuous semi-circular edges.
    
- **Developable Surface:** The surface of a sphericon is developable, meaning it can be flattened onto a plane without stretching or tearing.
    
- **Rolling Motion:** When rolled on a flat surface, it wobbles in a meandering straight line rather than rolling in a circle or a straight path like a cylinder.
    

---

[Incredibly Satisfying Sphericons](https://www.youtube.com/watch?v=wb29-ULRBaE)

This video is relevant because it demonstrates the physical properties of the sphericon, including its unique meandering rolling motion and how it is constructed from a bicone.
---
Here is the updated OpenSCAD code with the rotation applied to the **Y-axis**.

This aligns the longest dimension (1.5 units) vertically along the **Z-axis** (standing up), while the original vertical axis of the cones points along the **X-axis**.

OpenSCAD

```
// Customizable Sphericon Dimensions
total_length = 1.5;  // The length of the sphericon (Originally along X)
total_height = 1.0;  // The diameter of the sphericon

// Internal Settings
$fn = 100;           // Smoothness
base_size = 10;      // Arbitrary base unit for calculation

module standard_sphericon() {
    r = base_size / 2;
    // Part A: First half of bicone
    intersection() {
        union() {
            cylinder(r1=r, r2=0, h=r);
            mirror([0,0,1]) cylinder(r1=r, r2=0, h=r);
        }
        translate([-r, -r, -r]) cube([r, r*2, r*2]);
    }
    
    // Part B: Second half (rotated 90 deg relative to Part A)
    rotate([90, 0, 0]) 
    mirror([1,0,0]) 
    intersection() {
        union() {
            cylinder(r1=r, r2=0, h=r);
            mirror([0,0,1]) cylinder(r1=r, r2=0, h=r);
        }
        translate([-r, -r, -r]) cube([r, r*2, r*2]);
    }
}

// FINAL GENERATION STEPS
// 1. Scale to requested dimensions
// 2. Rotate 90 degrees around Y axis
rotate([0, 90, 0]) 
    scale([total_length/base_size, total_height/base_size, total_height/base_size]) 
    standard_sphericon();
```

### Orientation Summary

- **Red Axis (X):** 1.0 unit (The tips of the cones now point this way).
    
- **Green Axis (Y):** 1.0 unit (The width remains unchanged).
    
- **Blue Axis (Z):** 1.5 units (The "stretched" length is now standing upright).
    

![Image of Sphericon geometric shape](https://encrypted-tbn2.gstatic.com/licensed-image?q=tbn:ANd9GcRTSe8Bf4XE5N8iJ653FM3EzU2XcOBJ3Zo6meNSN24hCM7CwXblm7BWUIkn1OT735val5XJrETmuRIwfi5Mf_AEL2PfpBXDvZW2nxTklCo_j1o1Da4)

Shutterstock

### Printing Tip

Because this rotation stands the object on a rounded end (or point), it will have very little contact with the print bed. If you intend to print this file, you will almost certainly need to enable **"Brim"** or **"Raft"** in your slicer software to keep it from falling over.