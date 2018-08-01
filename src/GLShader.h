//
//  GLShader.hpp
//  GLShader
//
//  Created by zhuang yusong on 2017/3/4.
//  Copyright © 2017年 zhuang yusong. All rights reserved.
//

#ifndef GLShader_hpp
#define GLShader_hpp
#include "GLCore.h"
#include <string>
using namespace std;

#if defined(USE_GLEW)
#include <GL/glew.h>
#else
#include <GLES3/gl3.h>
#include <GL/glu.h>
#include <GL/glext.h>
#endif

class GLCORE GLShader{
    
public:
    
    GLShader();
    
    void createVertex();
    
    void createFragment();
    
    void createGeometry();
  
    void create(GLenum type);
    
    void compile(const char* source);
    
    GLuint getShader();
    
    std::string getError();
    
protected:
    
    GLuint m_shader;
    
    std::string m_error;
};


#endif /* GLShader_hpp */
