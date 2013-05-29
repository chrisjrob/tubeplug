// tubeplug.scad
// Tube Plug or Chair Feet
// 
// Copyright 2013 Christopher Roberts

// This should be the only variable that needs changing for different tube sizes
// Should be equal to the diameter of the outside of your tube
cap_diameter        = 25;
cap_thickness       = 4;

// The tube part
tube_diameter       = cap_diameter * 0.8;
tube_length         = 12.5; // Length of the tube part

// The "fins" to hold the inside of the actual tube
fin_overhang        = ((cap_diameter - tube_diameter)/2) * 0.7; // Must be less than or equal to ()cap_diameter - tube_diameter)/2
fin_height          = tube_length * 0.9; // Must be less than tube_length
fin_thickness       = 0.6;  // Thickness of fins
fin_h_angle         = -45;  // Horizontal angle of the fins
fin_v_angle         = -7;   // Vertical angle of the fins

// Other settings
thickness           = 1;    // Thickness of surfaces
fineness            = 200;  // Sets the circular precision, 20 - 200
cutaway             = 0;    // Enables you to cutaway half the model for checking integrity

// Calculate length of fins
fin_opposite        = abs( tan(fin_h_angle) * (fin_overhang + thickness) );
fin_length          = sqrt( pow(fin_overhang,2) + pow( fin_opposite,2 ) );

module tubeplug() {

    difference() {

        // Things that exist
        union() {

            // Cap
//            intersection(){
//                cylinder( h = cap_thickness, r = cap_diameter/2, $fn = fineness);
//                translate( v = [0,0,cap_thickness]) sphere( r = cap_diameter/2, $fn = fineness);
//            }
            cylinder( h = cap_thickness, r2 = cap_diameter*0.5, r1 = cap_diameter*0.42, $fn = fineness);

            // Tube
            translate( v = [0,0,cap_thickness]) {
                cylinder( h = tube_length, r = tube_diameter/2, $fn = fineness );
            }

            // fin
            for (a = [ 0 : (360/15) : 360 ] ) {
                rotate( a = [0, 0, a]) {
                    translate( v = [ tube_diameter/2 - thickness, 0, cap_thickness * 0.75] ) {
                        // cube( size = [fin_overhang + thickness, fin_thickness, tube_length]);
                        rotate( a = [0, -7, fin_h_angle]) {
                            cube( size = [fin_length, fin_thickness, fin_height]);
                        }
                    }
                }
            }
        }

        // Things to be cut out
        union() {
            translate( v = [0,0,thickness]) {
                cylinder( h = tube_length + cap_thickness, r = tube_diameter/2 - thickness, $fn = fineness );
            }
            if (cutaway == 1) {
                translate( v = [-cap_diameter/2, -cap_diameter/2, 0]) {
                    cube( size = [ cap_diameter, cap_diameter/2, cap_thickness + tube_length ]);
                }
            }
        }
    }

}

tubeplug();
