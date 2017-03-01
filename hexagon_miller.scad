/* Design for a nested hexagon keychain in OpenSCAD (www.openscad.org)
    (c) M.G. Klopper, (2016,2017)
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


// This is designed for milling operations, but with some modifications this part could be 3d printed
// A hole for a ring or string is not included in the design


flat = 16 ;                             //stock diameter, across flats
point = (flat/cos(30));                 //calculated point to point diameter
flat_radius = flat/2;                   //center to edge
point_radius = (flat_radius/cos(30));   //center to point  

slot_width = 2;                         //slot width (not necessarily milling cutter size)
slice=4;                                //thickness of hexagon
top = flat/2;                           //datum for the 'difference' calculations

circle_radius = flat_radius - ((slice-slot_width)/2);   // center hole, from calculations. slot depth is based on this
//circle_radius = 4;  // direct 

zero_x = 0;                 // datums for calculations
zero_y = 0;
zero_z = flat_radius/2;
    
$fn=20;

difference(){
    rotate([90,0,0])    translate([0,0,-slice/2])
    hexagon(flat_radius,slice); // Create the blank hexagon

        for(i= [0:5]){
            rotate([0,i*60,0])              // do on all rim edges 
                      
            slot_x(slot_width,flat_radius-circle_radius+ 0.50,  // diminsion slot according to circular cut on side, if the depth is increased the width should be too
            
                -(point_radius/2) +(slice-slot_width)/2 + slot_width/2 ,0
                , point_radius - (2 * (slice-slot_width)/2) - 2*(slot_width/2));
            
            //            (-(point_radius/2)+((slice-slot_width)/2)+slot_width/2)
            
            echo("x from center", -(point_radius/2) +(slice-slot_width)/2 + slot_width/2);
            echo("x travel", point_radius - (2 * (slice-slot_width)/2) - 2*(slot_width/2));
                        
            offset_zero_x1=0;
            offset_zero_y1=0;
            offset_zero_z1=0;
            
        };
        
        circle_depth = (slice-slot_width)/2+0.01;   // +0.01 to make it easier to edit with preview
        //and also get the inner hexagon a bit thinner than the slots on the rim. 
                
        for(i= [0:1]){
            rotate([0,0,+(i*180)])                  //front and back
            translate([0,(slice/2)-circle_depth],0)    
                rotate([-90,0,0])                   // align with part
                cylinder(r=circle_radius,circle_depth + 0.1 ,center=false); 
                // +0.1 for editing, extends the cylinder beyond the surface of the hexagon
        };
        
    };

 
 //      rotate([90,0,0])translate([0,0,-slice/2]) hexagon(3,1);    


//module hole(size, depth,x=0,y=0){
//slot(size,depth,x,y,travel_x,travel_y){    
    
    
module hexagon(radius,width)
{
    r=radius/cos(30);
linear_extrude(height=slice)
    polygon(points=[
    [r*sin(30),r*cos(30)],
    [r*sin(90),r*cos(90)],
    [r*sin(150),r*cos(150)],
    [r*sin(210),r*cos(210)],
    [r*sin(270),r*cos(270)],
    [r*sin(330),r*cos(330)]]   
    ,paths = [[0,1,2,3,4,5]]);
}

module hole(size,depth,x=0,y=0){

    translate([x,y,-depth])
    cylinder(h=depth+0.1,d=size);
};

module slot_x(size, depth, x,y, travel){
color([1,0,0,1])translate([x,y,top-depth])    
rotate([0,0,0]) slot(size,depth,travel);         
};

module slot_y(size, depth, x,y, travel){
translate([x,y,-depth])    
rotate([0,90,0]) slot(size,depth,travel);     
};

module slot(size,depth,travel){
        // +0.01 for editing, extends the shape beyond the surface of the hexagon
        
        cylinder(h=depth+0.01,d=size);

        if (travel<0){
                translate([travel,-size/2,0])
                    cube([abs(travel),size,depth+0.01],center=false);
               }
            else {
                translate([0,-size/2,0])
                    cube([abs(travel),size,depth+0.01],center=false);
        };
    
        translate([travel,0,0])
            cylinder(h=depth+0.01,d=size);

};

//EOF