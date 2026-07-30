// 11-Strand Continuous Torsion Coil with Color Gradient
$fn = 48; 

// --- Torsion Parameters ---
major_r = 35;  
minor_r = 15;  
strands = 11;  
twists  = 1;   
thickness = 1.5;
step = 10; 

// --- Sphericon Parameters ---
total_length = 24;  
total_height = 24;  
base_size = 10;     

module continuous_torsion_coil() {
    total_rotation = strands * 360;
    
    for (t = [0 : step : total_rotation - step]) {
        // Calculate Hue: 0.0 to 1.0 based on progress through the 11 loops
        // This creates a gradient that shifts every 360 degrees
        hue = (t / total_rotation);
        
        current_offset = (t / 360) * (360 / strands);
        
        // Point 1
        x1 = (major_r + minor_r * cos(t * twists + current_offset)) * cos(t);
        y1 = (major_r + minor_r * cos(t * twists + current_offset)) * sin(t);
        z1 = minor_r * sin(t * twists + current_offset);
        
        // Point 2
        t2 = t + step;
        next_offset = (t2 / 360) * (360 / strands);
        x2 = (major_r + minor_r * cos(t2 * twists + next_offset)) * cos(t2);
        y2 = (major_r + minor_r * cos(t2 * twists + next_offset)) * sin(t2);
        z2 = minor_r * sin(t2 * twists + next_offset);

        // Apply the color gradient to each segment
        color(hsv(hue * 360, 0.8, 1)) {
            hull() {
                translate([x1, y1, z1]) sphere(r = thickness);
                translate([x2, y2, z2]) sphere(r = thickness);
            }
        }
    }
}

module standard_sphericon() {
    r = base_size / 2;
    intersection() {
        union() {
            cylinder(r1=r, r2=0, h=r);
            mirror([0,0,1]) cylinder(r1=r, r2=0, h=r);
        }
        translate([-r, -r, -r]) cube([r, r*2, r*2]);
    }
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

// 1. Generate the Continuous Coil with Gradient
continuous_torsion_coil();

// 2. Generate the Sphericon Core (Stator)
color("White", 0.8) // Slight transparency to see the coil interaction
rotate([0, 90, 0]) 
    scale([total_length/base_size, total_height/base_size, total_height/base_size]) 
    standard_sphericon();

// Helper function for HSV to RGB conversion (OpenSCAD 2021.01+)
function hsv(h, s, v) = 
    let (
        c = v * s,
        x = c * (1 - abs((h / 60) % 2 - 1)),
        m = v - c,
        rgb = 
            h < 60  ? [c, x, 0] :
            h < 120 ? [x, c, 0] :
            h < 180 ? [0, c, x] :
            h < 240 ? [0, x, c] :
            h < 300 ? [x, 0, c] :
                      [c, 0, x]
    ) [rgb[0] + m, rgb[1] + m, rgb[2] + m];