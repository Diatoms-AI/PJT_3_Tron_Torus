// 11-Strand Continuous Torsion Coil with Color Gradient (Smooth Swept Tube, No Dependencies)
$fn = 64;

// --- Torsion Parameters ---
major_r = 35;  
minor_r = 15;  
strands = 11;  
twists  = 1;   
thickness = 2;
step = 2;           // angular resolution of the path (degrees) — lower = smoother curve
tube_sides = 12;    // number of sides around the tube's circular cross-section
chunk_points = 40;  // how many path points per colored segment (bigger = fewer color bands, faster render)

// Generates the coil centerline as a list of [x, y, z] points
function coil_path() = 
    let(total_rotation = strands * 360)
    [
        for (t = [0 : step : total_rotation])
            let(
                offset = (t / 360) * (360 / strands),
                x = (major_r + minor_r * cos(t * twists + offset)) * cos(t),
                y = (major_r + minor_r * cos(t * twists + offset)) * sin(t),
                z = minor_r * sin(t * twists + offset)
            )
            [x, y, z]
    ];

// Builds a circular cross-section ring of points around a given center,
// oriented perpendicular to the local path direction.
function make_ring(center, dir, r, sides) =
    let(
        // Pick an arbitrary "up" vector not parallel to dir
        up_guess = (abs(dir[2]) < 0.99) ? [0, 0, 1] : [1, 0, 0],
        // Build two perpendicular basis vectors in the cross-section plane
        u = norm_v(cross_v(dir, up_guess)),
        v = norm_v(cross_v(dir, u))
    )
    [
        for (a = [0 : 360/sides : 360 - 360/sides])
            center + r * (u * cos(a) + v * sin(a))
    ];

function cross_v(a, b) = [
    a[1]*b[2] - a[2]*b[1],
    a[2]*b[0] - a[0]*b[2],
    a[0]*b[1] - a[1]*b[0]
];

function norm_v(v) = v / norm(v);

// Builds a smooth tube polyhedron following a given path
module tube_along_path(path, r, sides) {
    n = len(path);
    
    // Compute local direction at each point (tangent)
    dirs = [
        for (i = [0 : n - 1])
            norm_v(
                i == 0 ? (path[1] - path[0]) :
                i == n - 1 ? (path[n-1] - path[n-2]) :
                (path[i+1] - path[i-1])
            )
    ];
    
    // Build all cross-section rings
    rings = [for (i = [0 : n - 1]) make_ring(path[i], dirs[i], r, sides)];
    
    // Flatten ring points into a single vertex list
    verts = [for (i = [0 : n - 1]) for (j = [0 : sides - 1]) rings[i][j]];
    
    // Build side faces connecting consecutive rings
    side_faces = [
        for (i = [0 : n - 2])
            for (j = [0 : sides - 1])
                each [
                    [ i*sides + j, i*sides + (j+1)%sides, (i+1)*sides + (j+1)%sides ],
                    [ i*sides + j, (i+1)*sides + (j+1)%sides, (i+1)*sides + j ]
                ]
    ];
    
    // Cap the start and end of the tube
    start_cap = [[for (j = [sides - 1 : -1 : 0]) j]];
    end_cap = [[for (j = [0 : sides - 1]) (n-1)*sides + j]];
    
    polyhedron(points = verts, faces = concat(side_faces, start_cap, end_cap));
}

module continuous_torsion_coil() {
    full_path = coil_path();
    num_points = len(full_path);

    for (i = [0 : chunk_points : num_points - 2]) {
        end_i = min(i + chunk_points, num_points - 1);
        chunk = [for (j = [i : end_i]) full_path[j]];
        
        hue = i / num_points;
        
        if (len(chunk) >= 2) {
            color(hsv(hue * 360, 0.8, 1))
                tube_along_path(chunk, thickness, tube_sides);
        }
    }
}

// 1. Generate the Continuous Coil with Gradient
continuous_torsion_coil();

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