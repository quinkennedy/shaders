// The fragment shader needs a main function, just as the 
// vertex shader does. But unlike a vertex shader, this is
// called for every pixel on the screen.

// All fragment shaders must end with the line
// gl_FragColor = vec4(*something*);
// because the fragment shader is setting the current color
// drawn on the screen.

// In the fragment shader, gl_FragColor will end up being
// the color that we want to display on the screen. In
// this case we are setting that to the color white, so every pixel
// belonging to our shape will be white.

// GLSL has a few different types, I recommend taking a look at the
// GLSL quick reference guide to get an idea of all of them.
// gl_FragColor takes the value of vec4() which is a 4 float
// vector. This can be written as vec4(red, green, blue, alpha)
// or you can even pass through other vec4's in the constructor,
// and even shorthand to vec4(1.0) to make all values 1.0. This will
// give us our white color.

// And that is all there is to shaders (for now).
// If you have followed through this far, well done. Give
// yourself a pat on the back :)

void main() {
	// Set the output color of our current pixel
	gl_FragColor = vec4(1.0);
}
