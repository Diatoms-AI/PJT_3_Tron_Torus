// --- 11 Nested Limaçons on Spindle Torus ---

// Parameters
a = 30; // Distance from center axis to tube center
b = 55; // Tube radius (Must be > a for the spindle shape)
num_loops = 11; // Number of nested copies

// Rendering Quality
torus_resolution = 10; 
curve_resolution = 360; 

// --- 1. The 11 Nested Limaçon Curves ---
// We loop 11 times, rotating the entire curve generation each time.
for (i = [0 : num_loops-1]) {
    
    rotate([0, 0, i * (360 / num_loops)]) // Rotate each copy
    color("cyan") 
    
    // Your Original Curve Logic
    for (t = [0 : curve_resolution-1]) {
        
        // Calculate current point
        theta1 = t;
        phi1   = t; 
        R1 = a + b * cos(phi1);
        
        x1 = R1 * cos(theta1);
        y1 = R1 * sin(theta1);
        z1 = b * sin(phi1);

        // Calculate next point
        theta2 = t + 1;
        phi2   = t + 1;
        R2 = a + b * cos(phi2);
        
        x2 = R2 * cos(theta2);
        y2 = R2 * sin(theta2);
        z2 = b * sin(phi2);

        // Draw curve segment
        hull() {
            translate([x1, y1, z1]) sphere(r = 1.5, $fn = 8);
            translate([x2, y2, z2]) sphere(r = 1.5, $fn = 8);
        }
    }
}

// --- 2. The Spindle Torus (Red) ---
// Your manual Hull Chain (kept for reference context)
// Made slightly more transparent to see the inner "nest"
color("red", 0.15) 
for (i = [0 : torus_resolution : 360-1]) {
    
    hull() {
        // Segment Start
        rotate([0, 0, i]) 
            translate([a, 0, 0]) 
            rotate([90, 0, 0]) 
            cylinder(r = b, h = 0.1, center = true, $fn = 40);
        
        // Segment End
        rotate([0, 0, i + torus_resolution]) 
            translate([a, 0, 0]) 
            rotate([90, 0, 0]) 
            cylinder(r = b, h = 0.1, center = true, $fn = 40);
    }
}