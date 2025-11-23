//------------------------------------------------------
// Rounded triangle defined by side lengths a, b, c
// with corner radius r and height h
//------------------------------------------------------

module rounded_triangle(a, b, c, r, h) {

    // place first point at origin
    p1 = [0, 0];

    // second point along +X axis
    p2 = [c, 0];

    // compute 3rd point using law of cosines
    // side a is opposite p1, side b opposite p2, side c opposite p3
    x3 = (b*b + c*c - a*a) / (2*c);
    y3 = sqrt(b*b - x3*x3);
    p3 = [x3, y3];

    // hull 3 cylinders at the corner points
    hull() {
        translate([p1[0], p1[1], 0])
            cylinder(h=h, r=r, $fn=64);

        translate([p2[0], p2[1], 0])
            cylinder(h=h, r=r, $fn=64);

        translate([p3[0], p3[1], 0])
            cylinder(h=h, r=r, $fn=64);
    }
}

//------------------------------------------------------
// Rounded RIGHT triangle
// base  = length along X
// height = length along Y
// r = corner radius
// h = extrusion height
//------------------------------------------------------

module rounded_right_triangle(base, height, r, h) {

    p1 = [0,      0];
    p2 = [base,   0];
    p3 = [0,  height];

    hull() {
        translate([p1[0], p1[1], 0])
            cylinder(h = h, r = r, $fn = 64);

        translate([p2[0], p2[1], 0])
            cylinder(h = h, r = r, $fn = 64);

        translate([p3[0], p3[1], 0])
            cylinder(h = h, r = r, $fn = 64);
    }
}


//-------------------------------------------
// trapezoid_centered()
// Creates a 3D trapezoid where the top width
// is centered above the bottom width.
//-------------------------------------------
// height   = Z height
// depth    = Y dimension (front to back)
// bottom_w = width of bottom (X)
// top_w    = width of top (X)
//-------------------------------------------

module trapezoid(bottom_w, top_w, depth, height) {

    dx = (bottom_w - top_w) / 2;

    pts = [
        // bottom (z = 0)
        [0,          0,      0],   // 0
        [bottom_w,   0,      0],   // 1
        [bottom_w,   depth,  0],   // 2
        [0,          depth,  0],   // 3

        // top (z = height)
        [dx,         0,      height], // 4
        [dx+top_w,   0,      height], // 5
        [dx+top_w,   depth,  height], // 6
        [dx,         depth,  height]  // 7
    ];

    faces = [
        // bottom (two triangles)
        [0,1,2], [0,2,3],

        // top (two triangles)
        [4,6,5], [4,7,6],

        // sides (two triangles each)
        [0,4,5], [0,5,1],
        [1,5,6], [1,6,2],
        [2,6,7], [2,7,3],
        [3,7,4], [3,4,0]
    ];

    polyhedron(points=pts, faces=faces);
}

module m3_hole() {
    $fn=120;
    #cylinder(d=6,h=5);
    m3();
}

module m3() {
    $fn=120;
    cylinder(d=3,h=20);
}


module frame() {
    h=190;
    w=128;
    lts=70;
    union() {
        difference() {
            trapezoid(height=h, depth=10, bottom_w=w, top_w=110);
            translate([w/2,10,(h/2-10)])
                rotate([90,0,0]) {
                    m3_hole();
                    
                    translate([0,12,0]) {
                        m3_hole();
                    }
                }
                
            // top
            translate([w/2+40,10,(h-15)]) {
                rotate([90,180,0])
                    rounded_triangle(a=lts,b=lts,c=80,r=6,h=10);
            }
            
            // bottom
            translate([w/2-40,10,10]) {
                rotate([90,0,0])
                    rounded_triangle(a=lts,b=lts,c=80,r=6,h=10);
            }
            
            // bottom-mid-left
            translate([15,0,78]) {
                rotate([90,180,180])
                    rounded_right_triangle(base=28,height=40,h=10,r=6);
            }
            
            // bottom-mid-right
            translate([113,10,78]) {
                rotate([90,180,0])
                    rounded_right_triangle(base=28,height=40,h=10,r=6);
            }
            
            
            // top-left
            translate([20,10,100]) {
                rotate([90,0,0])
                    rounded_right_triangle(base=28,height=40,h=10,r=6);
            }
            
            // top-right
            translate([109,0,100]) {
                rotate([90,0,180])
                    rounded_right_triangle(base=28,height=40,h=10,r=6);
            }
            
            // screw holes on top
            translate([20,5,h-5]) {
                m3();
            }
            translate([128-20,5,h-5]) {
                m3();
            }
            translate([128/2,5,h-5]) {
                m3();
            }

        }
        difference() {
            translate([-54,0,-10])
                cube([128+(54*2),10,10]);
                
            rotate([0,0,0]) {
                translate([-15,5,-10]) m3_hole();
                translate([-42,5,-10]) m3_hole();
            }
            rotate([0,0,0]) {
                translate([128+15,5,-10]) m3_hole();
                translate([128+42,5,-10]) m3_hole();
            }
        }
    }
}


module top() {
    difference() {
        cube([110,160,7]);
        
        translate([-9,0,0]) {

            translate([20,5,-3]) {
                #m3_hole();
            }
            translate([128-20,5,-3]) {
                #m3_hole();
            }
            translate([128/2,5,-3]) {
                #m3_hole();
            }
            
            translate([20,155,-3]) {
                #m3_hole();
            }
            translate([128-20,155,-3]) {
                #m3_hole();
            }
            translate([128/2,155,-3]) {
                #m3_hole();
            }
        }
        
        // Cutouts
        translate([15,20,0])
            rounded_right_triangle(base=30, height=50, r=6, h=7);      
        rotate([0,180,0]) translate([-95,20,-7])
            rounded_right_triangle(base=30, height=50, r=6, h=7);
        rotate([0,0,180]) translate([-70,-70,0])
        rounded_triangle(a=30,b=30,c=30,r=6,h=7); 
    
        rotate([0,0,180]) translate([-110, -160, 0]) {
            translate([15,20,0])
                rounded_right_triangle(base=30, height=50, r=6, h=7);      
            rotate([0,180,0]) translate([-95,20,-7])
                rounded_right_triangle(base=30, height=50, r=6, h=7);
            rotate([0,0,180]) translate([-70,-70,0])
            rounded_triangle(a=30,b=30,c=30,r=6,h=7);     
       }
    }
}

module mid_brace() {
    difference() {
        cube([15,140,40]);
        rotate([90,0,0]) translate([7.5,26,-220]) {
            $fn=120;
            #cylinder(d=3,h=300);
            translate([0,-12,0])
            #cylinder(d=3,h=300);
            
            // Top and Bottom cut outs
            translate([0,15,80]) cylinder(d=10, h=140);
            translate([0,-27,80]) cylinder(d=10, h=140);
            
        }
        rotate([0,90,0]) translate([-29,12,0]) {
            #rounded_right_triangle(base=18, height=25, r=6, h=15); 
            rotate([180,0,-90]) translate([-50,-18,-15])
            #rounded_right_triangle(base=22, height=18, r=6, h=15); 
            
            rotate([180,180,-90]) translate([66,-18,0])
            #rounded_right_triangle(base=22, height=18, r=6, h=15); 
            
            translate([0,116,15]) rotate([180,0,0])
            #rounded_right_triangle(base=18, height=25, r=6, h=15); 
        }
    }
}

module foot_rest() {
    difference() {
        cube([53.5,160,5]);
        translate([12,5,-16]) #m3();
        translate([39,5,-16]) #m3();
        translate([12,155,-16]) #m3();
        translate([39,155,-16]) #m3();
    }
}

frame();
translate([-54,0,0]) foot_rest();
translate([128,0,0]) foot_rest();
translate([56.5,12,71]) {
    mid_brace();
}
translate([9,0,190]) top();
translate([0,150,0]) frame();