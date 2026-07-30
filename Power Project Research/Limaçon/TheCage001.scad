// --- 11 Nested Limaçons with Corrected Sphericon ---

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
// Fits inside the 20-unit radius hole.
// We scale it to be 1.5 units long (Z) by 1 unit wide (XY) relative to its base size.
base_radius = 12; // Base size (fits comfortably in R=20 hole)
scale_vector = [1, 1, 1.5]; // Elongated along Z-axis (1.5x)

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
// 2. The Sphericon (Corrected Orientation)
// ==========================================
// Construction: Hull of two orthogonal semicircles.
// Aligned to X/Z and Y/Z planes.
color("gold")
scale(scale_vector) // Apply the 1.5 length vs 1 width aspect ratio
hull() {
    // Semicircle 1 ( Lying in XZ plane )
    rotate([90, 0, 0]) // Rotate to vertical plane
    intersection() {
        circle(r = base_radius, $fn=60);
        translate([0, base_radius/2, 0]) square([base_radius*2, base_radius], center=true);
    }
    
    // Semicircle 2 ( Lying in YZ plane )
    rotate([90, 0, 90]) // Rotate to vertical plane, then 90 deg around Z
    intersection() {
        circle(r = base_radius, $fn=60);
        translate([0, -base_radius/2, 0]) square([base_radius*2, base_radius], center=true);
    }
}