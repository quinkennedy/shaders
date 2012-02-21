#if ( (defined(__MACH__)) && (defined(__APPLE__)) )   
#include <stdlib.h>
#include <OpenGL/gl.h>
#include <GLUT/glut.h>
#include <OpenGL/glext.h>
#else
#include <stdlib.h>
//#include <GL/glew.h>
#include <GL/gl.h>
#include <GL/glut.h>
#include <GL/glext.h>
#endif

#include "shader.h"

Shader shader;

GLfloat angle = 0.0; //set the angle of rotation

void init(void) {
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);
    
    shader.init("shader.vert", "shader.frag");
}

void cube (void) {
	glRotatef(angle, 1.0, 0.0, 0.0); //rotate on the x axis
	glRotatef(angle, 0.0, 1.0, 0.0); //rotate on the y axis
	glRotatef(angle, 0.0, 0.0, 1.0); //rotate on the z axis
	glColor4f(1.0, 0.0, 0.0, 1.0);
	glutWireCube(2);
}

void display (void) {
	glClearColor (0.0,0.0,0.0,1.0);
    glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();  
	gluLookAt (0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    
    shader.bind();
	cube();
    shader.unbind();
	
    glutSwapBuffers();
	angle += 0.01f;
}

void reshape (int w, int h) {
	glViewport (0, 0, (GLsizei)w, (GLsizei)h);
	glMatrixMode (GL_PROJECTION);
	glLoadIdentity ();
	gluPerspective (60, (GLfloat)w / (GLfloat)h, 1.0, 100.0);
	glMatrixMode (GL_MODELVIEW);
}

int main (int argc, char **argv) {
    glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH); //set up the double buffering
	glutInitWindowSize(500, 500);
	glutInitWindowPosition(100, 100);
    glutCreateWindow("A basic OpenGL Window");
    
    glutDisplayFunc(display);
	glutIdleFunc(display);
	
    glutReshapeFunc(reshape);
    
    init();
    
    glutMainLoop();
    
    return 0;
}

