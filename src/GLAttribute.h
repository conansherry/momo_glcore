//
//  GLAttribute.hpp
//  GLAttribute
//
//  Created by zhuang yusong on 2017/3/5.
//  Copyright © 2017年 zhuang yusong. All rights reserved.
//

#ifndef GLAttribute_hpp
#define GLAttribute_hpp
#include "GLCore.h"
#if defined(USE_GLEW)
#include <GL/glew.h>
#else
#include <GLES3/gl3.h>
#include <GL/glu.h>
#include <GL/glext.h>
#endif

class GLCORE GLAttribute{
    
public:
    
    GLAttribute();
    
    GLAttribute(GLuint program, GLuint attribute);
    
    void init(GLuint attribute);
    
    void enableVertexAttribArray();
    
    void enableVertexAttribArray(GLuint attribute);
    
    void disableVertexAttribArray();
    
    void vertexAttribPointer(GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid *pointer);
    
    void vertexAttrib4f(GLfloat x, GLfloat y, GLfloat z, GLfloat w);
    
protected:
    
    GLuint m_attribute;
    
    GLuint m_program;
};


#endif /* GLAttribute_hpp */
