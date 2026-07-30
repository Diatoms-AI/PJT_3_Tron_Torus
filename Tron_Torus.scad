// 11-Strand Continuous Torsion Coil (Without Sphericon)
$fn = 48; // Resolution

// --- Torsion Parameters ---
major_r = 35;  
minor_r = 15;  
strands = 11;  
twists  = 1;   
thickness = 1.5;
step = 10; // Angular resolution of the path

module continuous_torsion_coil() {
    // Total rotation spans all 11 loops (11 * 360 = 3960 degrees)
    total_rotation = strands * 360;
    
    for (t = [0 : step : total_rotation - step]) {
        // Calculate Hue: 0.0 to 1.0 based on progress through the 11 loops
        // Shifts smoothly around the spectrum every 360 degrees
        hue = (t / total_rotation);
        
        current_offset = (t / 360) * (360 / strands);
        
        // Point 1 (Current)
        x1 = (major_r + minor_r * cos(t * twists + current_offset)) * cos(t);
        y1 = (major_r + minor_r * cos(t * twists + current_offset)) * sin(t);
        z1 = minor_r * sin(t * twists + current_offset);
        
        // Point 2 (Next)
        t2 = t + step;
        next_offset = (t2 / 360) * (360 / strands);
        x2 = (major_r + minor_r * cos(t2 * twists + next_offset)) * cos(t2);
        y2 = (major_r + minor_r * cos(t2 * twists + next_offset)) * sin(t2);
        z2 = minor_r * sin(t2 * twists + next_offset);

        // Render each segment with its gradient color
        color(hsv(hue * 360, 0.8, 1)) {
            hull() {
                translate([x1, y1, z1]) sphere(r = thickness);
                translate([x2, y2, z2]) sphere(r = thickness);
            }
        }
    }
}

// Generate the Continuous Coil
continuous_torsion_coil();

// Helper function for HSV to RGB conversion
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