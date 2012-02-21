// This is pretty much the most basic of vertex shaders. Vertex shaders
// allow for us to manipulate the vertices of an object. The major 
// advantage of this would be if you were moving vertices or a mass
// group of vertices, in a particular way. For example, water could
// be created with a plane tesselated enough, and the vertex shader
// would be faster at computing the positions of the vertices than 
// if you were doing it in immediate mode.

// Anyway, this shader, just like all other GLSL shaders, has a main
// function, it is possible to have other functions inside a shader,
// but OpenGL will look for the main function and call it.

// Inside our main function, I am setting the position of the vertices
// to exactly where they would be if I hadn't used this shader. We are
// multiplying the projection matrix, by the current vertex to place
// the vertex where it should belong.

// The variable gl_Position, is used to set the position of the current
// vertex. Another method of setting the vertex to where it should be
// without shaders, to set gl_Position to ftransform; ftransform is a
// GLSL variable that does the exact same as 
// glModelViewProjectionMatrix * glVertex;

// I don't use ftransform() personally, and I believe it is even deprecated
// when using geometry shaders. (Just don't quote me on that)

// So all this shader will do is place the vertices we are drawing to where
// they should have been in the first place. 

// *Note* All vertex shaders are called for every vertex individually.

// Every vertex shader, needs to have the line
// gl_Position = *something*;
// because the point of the vertex shader is to set the positions of
// the vertices.

void main() {			
	// Set the position of the current vertex 
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}