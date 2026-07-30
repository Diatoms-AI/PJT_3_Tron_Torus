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