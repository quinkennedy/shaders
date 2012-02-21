#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <windows.h>
//#include <GL/gl.h>
//#include <GL/glu.h>
#include <GL/glut.h>
using namespace std;

void display(void){
	glClear(GL_COLOR_BUFFER_BIT);
	glColor3f(1.0,1.0,1.0);
	glBegin(GL_POLYGON);
		glVertex3f(0.25, 0.25, 0.0);
		glVertex3f(0.75, 0.25, 0.0);
		glVertex3f(0.75, 0.75, 0.0);
		glVertex3f(0.25, 0.75, 0.0);
	glEnd();
	glFlush();
}
/*
unsigned long getFileLength(ifstream& file){
	if(!file.good())
		return 0;
	unsigned long pos = file.tellg();
	file.seekg(0, ios::end);
	unsigned long len = file.tellg();
	file.seekg(ios::beg);
	return len;
}

int loadshader(char* filename, GLchar** ShaderSource, unsigned long* len){
	ifstream file;
	file.open(filename, ios::in);
	if (!file)
		return -1;
	len = getFileLength(file);
	if (len == 0)
		return -2;

	*ShaderSource = (GLubyte*) new char[len+1];
	if (*ShaderSource == 0)
		return -3;

	*ShaderSource[len] = 0;
	unsigned int i = 0;
	while(file.good()){
		*ShaderSource[i] = file.get();
		if (!file.eof())
			i++;
	}
	*ShaderSource[i] = 0;
	file.close();
	return 0;
}

int unloadshader(GLubyte** ShaderSource){
	if (*ShaderSource != 0){
		delete[] *ShaderSource;
	}
	*ShaderSource = 0;
}
*/
void init(void){
	glClearColor(0.0,0.0,0.0,0.0);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(0.0, 1.0, 0.0, 1.0, -1.0, 1.0);
}

int main(int argc, char** argv) {
std::cout << "This is a native c++ program." << std::endl;
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_SINGLE|GLUT_RGB);
	glutInitWindowSize(250,250);
	glutInitWindowPosition(100,100);
	glutCreateWindow("hello");
	init();
	glutDisplayFunc(display);
	glutMainLoop();
	return 0;
}
