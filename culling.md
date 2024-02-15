# Current state

The current version uses integer coordinate lists of x, y and z with screen size scaling.  
These coordinates are rotated by fixed point computation and result in integer coordinates.  
Then, are projected as integers and moved into screen center.  
The most expensive part is the rotation.

# Planes

To be able to cull non visible parts of the space ship we have to introduce planes. A plane has a normal that can be checked against the camera normal for culling.  
By simply making planes from the given coordinates we would double or triple the number of points. Each plane would hold a coordinate again. Therefore we define a plane from indices into the coordinate list.

Per plane we need another coordinate that is not drawn. It is the end point of the normal of the plane. The start point is one of the drawn points of the plane.

So, we have a list of indices per plane. The first index points to the normal end point in the coordinate list. The other indices point to the drawn plane coordinates.

# Culling

Before rotating all the coordinates of a plane we rotate only the two points of the plane normal and check if the difference of the z-component is negative. If so, we can drop drawing the plane. It is facing away from the camera.  
If not, we only rotatad one additional point per plane.

# Drawing planes

For drawing the planes we can use the AREA-commands of the graphics library.