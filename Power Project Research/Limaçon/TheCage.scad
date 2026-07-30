// --- 11 Nested Limaçons with Solid Sphericon ---

// --- Parameters ---
limacon_a = 30; 
limacon_b = 50; 
num_loops = 11; 

// --- Derived Dimensions ---
horn_size = abs(limacon_a - limacon_b); // 20 (Hole Radius)
outer_size = limacon_a + limacon_b;     // 80
R_major = (outer_size + horn_size) / 2; // 50
r_minor = (outer_size - horn_size) / 2; // 30

// --- Sphericon Settings ---
base_radius = 12; // Fits inside the R=20 hole
// Scale: Z is 1.5x larger than X/Y to match "1.5 long by 1 high" ratio
// assuming "long" aligns with the vertical tunnel.
scale_vector = [1, 1, 1.5]; 

// Rendering
steps = 360; 
curve_thickness = 1.0; 

// ==========================================
// 1. The 11 Nested Limaçon Loops (The Cage)
// ==========================================
for (i = [0 : num_loops-1]) {
    rotate([0, 0, i * (360 / num_loops)]) 
    color(c = [0, 0.8, 1]) // Cyan
    union() {
        for (t = [0 : steps-1]) {
            theta = t; 
            phi = t;   
            
            // Calc Points
            dist1 = R_major + r_minor * cos(phi);
            x1 = dist1 * cos(theta);
            y1 = dist1 * sin(theta);
            z1 = r_minor * sin(phi);

            theta2 = t + 1;
            phi2 = t + 1;
            dist2 = R_major + r_minor * cos(phi2);
            x2 = dist2 * cos(theta2);
            y2 = dist2 * sin(theta2);
            z2 = r_minor * sin(phi2);

            hull() {
                translate([x1, y1, z1]) sphere(r = curve_thickness, $fn = 8);
                translate([x2, y2, z2]) sphere(r = curve_thickness, $fn = 8);
            }
        }
    }
}

// ==========================================
// 2. The Solid Sphericon
// ==========================================
color("gold")
scale(scale_vector)
hull() {
    // 1. Vertical Plate (XZ Plane)
    rotate([90, 0, 0]) // Stand it up
    linear_extrude(height=0.1, center=true) // Make it 3D!
    intersection() {
        circle(r=base_radius, $fn=60);
        translate([0, base_radius/2]) square([base_radius*2, base_radius], center=true);
    }
    
    // 2. Vertical Plate (YZ Plane) - Rotated 90 deg
    rotate([90, 0, 90]) // Stand up and rotate
    linear_extrude(height=0.1, center=true) // Make it 3D!
    intersection() {
        circle(r=base_radius, $fn=60);
        translate([0, -base_radius/2]) square([base_radius*2, base_radius], center=true);
    }
}