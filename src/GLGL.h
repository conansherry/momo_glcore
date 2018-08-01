#ifndef GL_GL_H
#define GL_GL_H
#include "GLCore.h"
#if defined(USE_GLEW)
#include <GL/glew.h>
#else
#include <GLES3/gl3.h>
#include <GL/glu.h>
#include <GL/glext.h>
#include <glfw3.h>
#endif

#endif
